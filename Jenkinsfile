#!/usr/bin/groovy
@Library('github.com/tanl200/jenkins-pipeline-library') _

def getGitBranchName() {
    return scm.branches[0].name
}

def stageWrapper(name, enable) {
	if (enable) {
		return stage(name)
	} else {
		return sh('echo Bypass')
	}	
}

def taskA() {
	commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID").trim()
}

def taskB() {
	action = sh(returnStdout: true, script: ". ./functions.sh && getCommitAction").trim()
}

node {

	deleteDir()

	def opsType = ''
	def action = ''

	def enablea = false
	def enableb = false

	stage ('Prepare') {
		def functions = libraryResource 'local/suker200/functions.sh'
		writeFile file: 'functions.sh', text: functions
	    commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID").trim()
	    opsType = sh(returnStdout: true, script: ". ./functions.sh && getOpsType").trim()
	    action = sh(returnStdout: true, script: ". ./functions.sh && getCommitAction").trim()
	}

	stage ('run') {
		stageWrapper('taskA', true)
		stageWrapper('taskB', true)
	}	
}
