from jinja2 import Template
from shutil import copyfile
import yaml
import sys
import json
import click
import os

def LoadConfig(configFilePath):
	dataConfig = open(configFilePath).read()
	config = yaml.load(dataConfig) #Load content of YAML file to yaml object
	return config

def OutputFile(data, filename):
	with open(filename, "wb") as fh:
		fh.write(data)

def OutputTerraformVarsFile(terraformVarsInfo, terraformVarsFilePath):
	with open(terraformVarsFilePath, 'wb') as output:
	  json.dump(terraformVarsInfo, output)

def RenderKopsTemplate(config, templateFilePath, outputFilePath):
	dataTemplate = open(templateFilePath).read()
	template = Template(dataTemplate)
	templateRenderOutput = template.render(config)
	OutputFile(templateRenderOutput, outputFilePath)

# Base on SUBNETS list, cidr and type, we output list public/private subnet for terraform subnet creation
def RenderTerraformVarsFile(config, terraformVarsFilePath):
	public_subnets , private_subnets , public_zones , private_zones = list(), list(), list(), list()
	public_subnet_tags, private_subnet_tags = dict(), dict()
	terraformVarsInfo = dict()
	for subnetBlock in config.get('SUBNETS'):
		if subnetBlock.get('type') is None:
			raise ValueError('subnet type is empty')
		elif subnetBlock.get('type') == 'Utility':
			public_subnets.append(subnetBlock.get('cidr'))
			public_zones.append(subnetBlock.get('zone'))
		elif subnetBlock.get('type') == 'Private':
			private_subnets.append(subnetBlock.get('cidr'))
			private_zones.append(subnetBlock.get('zone'))

	if config.get('SUBNET_TAGS') is not None:
		for subnetType, tags in config.get('SUBNET_TAGS').iteritems():
			if subnetType == 'utility':
				terraformVarsInfo['public_subnet_tags'] = tags
			elif subnetType == 'private':
				terraformVarsInfo['private_subnet_tags'] = tags
			else:
				raise ValueError('Subnet Tags type is not correct')

	terraformVarsInfo['public_subnets'] = ",".join(public_subnets)
	terraformVarsInfo['public_zones'] = ",".join(public_zones)
	terraformVarsInfo['private_subnets'] = ",".join(private_subnets)
	terraformVarsInfo['private_zones'] = ",".join(private_zones)

	terraformVarsInfo['cluster_name'] = config.get('CLUSTER_NAME')

	terraformVarsInfo['worker_sg_name'] = "nodes.{}".format(config.get('CLUSTER_NAME'))

	terraformVarsInfo['vpc_id'] = config.get('VPC_ID')

	terraformVarsInfo['asg_ingress_name'] = {
		'ingress_external_l7': 'ingress-external-l7.{}'.format(config.get('CLUSTER_NAME')),
		'ingress_external_tcp': 'ingress-external-tcp.{}'.format(config.get('CLUSTER_NAME')),
		'ingress_internal_tcp': 'ingress-internal-tcp.{}'.format(config.get('CLUSTER_NAME'))
	}

	for key, value in config.get('TERRAFORM_VARS').iteritems():
		terraformVarsInfo[key] = value

	OutputTerraformVarsFile(terraformVarsInfo, terraformVarsFilePath)

@click.command()
# @click.option('--cloud_provider', required=True, help='cloud provider')
@click.option('--config', required=True, type=click.Path(exists=True,readable=True,allow_dash=True,file_okay=True), help='config file')
@click.option('--template', required=True, type=click.Path(exists=True,readable=True,allow_dash=True,file_okay=True), help='kops template file')
@click.option('--project', required=True, help='project name')
def Kops(config, template, project):
	kops_dir = "projects/{}/kops".format(project)
	non_kops_dir = "projects/{}/non_kops".format(project)
	if not os.path.isdir(kops_dir):
		os.mkdir(kops_dir)

	if not os.path.isdir(non_kops_dir):
		os.mkdir(non_kops_dir)

	if not os.path.isfile("{}/project.tf".format(non_kops_dir)):
		copyfile("projects/example/kops_example/project.tf", "{}/project.tf".format(non_kops_dir))
	config = LoadConfig(config)
	RenderKopsTemplate(config, template, "{}/kops_cluster.yaml".format(kops_dir))
	RenderTerraformVarsFile(config, "{}/terraform.auto.tfvars".format(non_kops_dir))
	OutputFile("CLUSTER_NAME={}".format(config.get('CLUSTER_NAME')), "{}/ENV".format(project),
		
if __name__ == '__main__':
    Kops()
