#!/usr/bin/groovy
@Library('github.com/tanl200/jenkins-pipeline-library') _

def getGitBranchName() {
    return scm.branches[0].name
}

def applyTerraform(functionFile, ) {
	
}

node {

	deleteDir()

	def scmVar = checkout scm
	def commitHash = scmVar.GIT_COMMIT
	def branch = scmVar.branchs[0].name

	def opsType = ''
	def action = ''

	stage ('Prepare') {
		def functions = libraryResource 'local/suker200/functions.sh'
		writeFile file: 'functions.sh', text: functions
	    commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID").trim()
	    opsType = sh(returnStdout: true, script: ". ./functions.sh && getOpsType").trim()
	    action = sh(returnStdout: true, script: ". ./functions.sh && getCommitAction").trim()
	}

	stage ('Test') {
		sh('echo $commitHash')
		sh('echo $branch')
	}
}
