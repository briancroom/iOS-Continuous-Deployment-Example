#!/usr/bin/python

import os
import sys
import subprocess
import json

api_token=os.environ.get('APP_DISTRIBUTION_TOKEN')
project_id='581'
phase_id='1193'

def call_curl(api_resource, form_fields):
	url = 'https://app-distribution.pivotal.io/api/v2/'+api_resource

	additional_args = []
	for (name, value) in form_fields.iteritems():
		additional_args.extend(['-F', name+'='+value])

	return subprocess.check_output(['curl', '-s', '-H', 'Authorization:Token token="%s"' % api_token, '-X', 'POST', url] + additional_args)

def create_build():
	response = call_curl('builds', {'phase_id': phase_id})
	return str(json.loads(response)['id'])

def upload_file_to_build(build_id, file_path):
	response = call_curl('resource_files', {'build_id': build_id, 'file': '@'+file_path})
	return str(json.loads(response)['id'])

def url_for_build(build_id):
	return 'https://app-distribution.pivotal.io/#/projects/%s/build/releases/%s' % (project_id, build_id)

def open_url(url):
	subprocess.call(['open', url])


if __name__ == '__main__':
	if not api_token:
		print("You must specify an App Distribution API token using the APP_DISTRIBUTION_TOKEN environment variable.")
		exit(1)

	if len(sys.argv) < 2:
		print("Usage: %s file_to_upload [another_file_to_upload...]" % sys.argv[0])
		exit(1)

	file_paths = sys.argv[1:]

	missing_files = [path for path in file_paths if not os.path.exists(path)]
	if len(missing_files) > 0:
		print("The following files don't exist: "+str(missing_files))
		exit(1)

	print("Creating new build...")
	build_id = create_build()
	print "Created build with ID: "+build_id

	for path in file_paths:
		print("Attaching %s to build..." % os.path.basename(path))
		upload_file_to_build(build_id, path)
		print("Done uploading")

	print "The new build can be accessed at: "+url_for_build(build_id)
	# open_url(url_for_build(build_id))
