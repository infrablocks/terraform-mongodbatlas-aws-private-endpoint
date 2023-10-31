# frozen_string_literal: true

require 'spec_helper'

describe 'private endpoint' do
  let(:region) do
    var(role: :root, name: 'region')
  end
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:allow_cidrs) do
    var(role: :root, name: 'allow_cidrs')
  end
  let(:project_id) do
    output(role: :prerequisites, name: 'project_id')
  end
  let(:vpc_id) do
    output(role: :prerequisites, name: 'vpc_id')
  end
  let(:subnet_ids) do
    output(role: :prerequisites, name: 'subnet_ids')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    describe 'MongoDB Atlas privatelink endpoint' do
      it 'creates a privatelink endpoint' do
        expect(@plan)
          .to(include_resource_creation(
            type: 'mongodbatlas_privatelink_endpoint'
          )
                .once)
      end

      it 'uses the provided region' do
        expect(@plan)
          .to(include_resource_creation(
            type: 'mongodbatlas_privatelink_endpoint'
          )
                .with_attribute_value(:region, region))
      end

      it 'uses the provided project ID' do
        expect(@plan)
          .to(include_resource_creation(
            type: 'mongodbatlas_privatelink_endpoint'
          )
                .with_attribute_value(:project_id, project_id))
      end

      it 'uses "AWS" as the provider name' do
        expect(@plan)
          .to(include_resource_creation(
            type: 'mongodbatlas_privatelink_endpoint'
          )
                .with_attribute_value(:provider_name, 'AWS'))
      end
    end

    describe 'AWS security group' do
      it 'creates a privatelink endpoint' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_security_group')
                .once)
      end

      it 'uses the provided VPC ID' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_security_group')
                .with_attribute_value(:vpc_id, vpc_id))
      end

      it 'includes component and deployment identifier tags' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_security_group')
                .with_attribute_value(
                  :tags,
                  a_hash_including(
                    Component: component,
                    DeploymentIdentifier: deployment_identifier
                  )
                ))
      end

      it 'includes an ingress rule allowing all access from the ' \
         'provided CIDRS' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_security_group_rule')
                .with_attribute_value(:type, 'ingress')
                .with_attribute_value(:protocol, '-1')
                .with_attribute_value(:from_port, 0)
                .with_attribute_value(:to_port, 0)
                .with_attribute_value(:cidr_blocks, allow_cidrs))
      end
    end

    describe 'AWS VPC endpoint' do
      it 'creates a VPC endpoint' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_vpc_endpoint')
                .once)
      end

      it 'uses the provided VPC ID' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_vpc_endpoint')
                .with_attribute_value(:vpc_id, vpc_id))
      end

      it 'uses a VPC endpoint type of "Interface"' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_vpc_endpoint')
                .with_attribute_value(:vpc_endpoint_type, 'Interface'))
      end

      it 'uses the provided subnet IDs' do
        expect(@plan)
          .to(include_resource_creation(type: 'aws_vpc_endpoint')
                .with_attribute_value(
                  :subnet_ids, match_array(subnet_ids)
                ))
      end
    end

    describe 'MongoDB Atlas privatelink endpoint service' do
      it 'creates an endpoint service' do
        expect(@plan)
          .to(include_resource_creation(
            type: 'mongodbatlas_privatelink_endpoint_service'
          )
                .once)
      end

      it 'uses a provider name of "AWS"' do
        expect(@plan)
          .to(include_resource_creation(
            type: 'mongodbatlas_privatelink_endpoint_service'
          )
                .with_attribute_value(:provider_name, 'AWS'))
      end
    end
  end
end
