#!/usr/bin/groovy
@Library('github.com/tanl200/jenkins-pipeline-library') _

def getGitBranchName() {
    return scm.branches[0].name
}

node {

	deleteDir()

	stage ('checkout') {
		checkout scm
	}
	
	def commitID = ''
	def opsType = ''
	def action = ''
	def branch = ''

	stage ('Prepare') {
		def functions = libraryResource 'local/suker200/functions.sh'
		writeFile file: 'functions.sh', text: functions
	    commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID").trim()
	    opsType = sh(returnStdout: true, script: ". ./functions.sh && getOpsType").trim()
	    action = sh(returnStdout: true, script: ". ./functions.sh && getCommitAction").trim()
    	branch = getGitBranchName()
	}

	stage ('TEST') {
	    notify {
	        slackChannel = "k8s-build"
	        message = "xxxx"
	        title = "uuu"
	        title_link = "hhhhhh"
	    }
	}
}
