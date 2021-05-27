require 'spec_helper'

describe 'Private Endpoint' do
  let(:component) { vars.component }
  let(:deployment_identifier) { vars.deployment_identifier }

  let(:region) { vars.region }

  let(:allow_cidrs) { vars.allow_cidrs }

  let(:project_id) { output_for(:prerequisites, "project_id") }

  let(:vpc_id) { output_for(:prerequisites, "vpc_id") }
  let(:subnet_ids) { output_for(:prerequisites, "subnet_ids") }

  let(:vpc_endpoint_id) do
    output_for(:harness, "vpc_endpoint_id")
  end

  it 'creates a privatelink endpoint for the project in the specified region' do
    private_endpoint_services = mongo_db_atlas_client
        .get_all_private_endpoint_services_for_provider(project_id, "AWS")

    expect(private_endpoint_services.length).to(eq(1))
    expect(private_endpoint_services[0]["id"]).not_to(be_nil)
    expect(private_endpoint_services[0]["status"]).to(eq("AVAILABLE"))
    expect(private_endpoint_services[0]["interfaceEndpoints"])
        .to(eq([vpc_endpoint_id]))
    expect(private_endpoint_services[0]["endpointServiceName"])
        .to(match(/#{region}/))
  end

  it 'creates a VPC endpoint in the provided subnets' do
    vpc_endpoint = vpc_endpoints(vpc_endpoint_id)

    expect(vpc_endpoint).to(belong_to_vpc(vpc_id))
    expect(vpc_endpoint.vpc_endpoint_type).to(eq("Interface"))

    subnet_ids.each do |subnet_id|
      expect(vpc_endpoint).to(have_subnet(subnet_id))
    end
  end

  it 'uses a default security group allowing all traffic from the ' +
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

  it 'creates a privatelink endpoint service attached to the VPC endpoint' do
    private_endpoint_services = mongo_db_atlas_client
        .get_all_private_endpoint_services_for_provider(
            project_id, "AWS")
    private_endpoint_service = private_endpoint_services[0]

    private_endpoint = mongo_db_atlas_client
        .get_one_private_endpoint_for_provider(
            project_id, "AWS", private_endpoint_service["id"], vpc_endpoint_id)

    expect(private_endpoint["interfaceEndpointId"]).to(eq(vpc_endpoint_id))
    expect(private_endpoint["connectionStatus"]).to(eq("AVAILABLE"))
  end
end
