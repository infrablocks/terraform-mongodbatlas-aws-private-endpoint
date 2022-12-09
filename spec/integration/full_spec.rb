# frozen_string_literal: true

require 'spec_helper'

RSpec::Matchers.define_negated_matcher(
  :not_nil, :be_nil
)

describe 'full' do
  let(:mongo_db_atlas_client) do
    MongoDBAtlasClient.new
  end

  let(:region) do
    var(role: :full, name: 'region')
  end
  let(:component) do
    var(role: :full, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :full, name: 'deployment_identifier')
  end

  let(:allow_cidrs) do
    var(role: :full, name: 'allow_cidrs')
  end

  let(:project_id) do
    output(role: :full, name: 'project_id')
  end
  let(:vpc_id) do
    output(role: :full, name: 'vpc_id')
  end
  let(:subnet_ids) do
    output(role: :full, name: 'subnet_ids')
  end

  let(:vpc_endpoint_id) do
    output(role: :full, name: 'vpc_endpoint_id')
  end

  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'private endpoint' do
    it 'creates a privatelink endpoint for the project in the ' \
       'specified region' do
      private_endpoint_services =
        mongo_db_atlas_client
        .get_all_private_endpoint_services_for_provider(
          project_id, 'AWS'
        )

      expect(private_endpoint_services)
        .to(contain_exactly(
              a_hash_including(
                'id' => not_nil,
                'status' => 'AVAILABLE',
                'interfaceEndpoints' => [vpc_endpoint_id],
                'endpointServiceName' => match(/.*#{region}.*/)
              )
            ))
    end

    it 'creates a VPC endpoint' do
      vpc_endpoint = vpc_endpoints(vpc_endpoint_id)

      expect(vpc_endpoint).to(belong_to_vpc(vpc_id))
    end

    it 'uses an endpoint type of "Interface" for the VPC endpoint' do
      vpc_endpoint = vpc_endpoints(vpc_endpoint_id)

      expect(vpc_endpoint.vpc_endpoint_type).to(eq('Interface'))
    end

    it 'uses the provided subnets for the VPC endpoint' do
      vpc_endpoint = vpc_endpoints(vpc_endpoint_id)

      subnet_ids.each do |subnet_id|
        expect(vpc_endpoint).to(have_subnet(subnet_id))
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses a default security group allowing all traffic from the ' \
       'provided CIDR' do
      vpc_endpoint = vpc_endpoints(vpc_endpoint_id)
      security_groups = vpc_endpoint.groups

      expect(security_groups.length).to(eq(1))

      security_group = security_group(security_groups[0].group_id)

      expect(security_group.inbound_rule_count).to(eq(1))

      ingress_rule = security_group.ip_permissions.first

      expect(ingress_rule.from_port).to(be_nil)
      expect(ingress_rule.to_port).to(be_nil)
      expect(ingress_rule.ip_protocol).to(eq('-1'))
      expect(ingress_rule.ip_ranges.map(&:cidr_ip)).to(eq(allow_cidrs))
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'creates a privatelink endpoint service attached to the VPC endpoint' do
      private_endpoint_services =
        mongo_db_atlas_client
        .get_all_private_endpoint_services_for_provider(
          project_id, 'AWS'
        )
      private_endpoint_service = private_endpoint_services[0]

      private_endpoint =
        mongo_db_atlas_client
        .get_one_private_endpoint_for_provider(
          project_id,
          'AWS',
          private_endpoint_service['id'],
          vpc_endpoint_id
        )

      expect(private_endpoint['interfaceEndpointId'])
        .to(eq(vpc_endpoint_id))
      expect(private_endpoint['connectionStatus'])
        .to(eq('AVAILABLE'))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
