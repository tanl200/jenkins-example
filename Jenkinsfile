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

def stage(name, execute, block) {
    return stage(name, execute ? block : {echo "skipped stage $name"})
}

node {

	deleteDir()
	stage ('checkout', true) {
		checkout scm
	}
	def opsType = ''
	def action = ''

	def enablea = false
	def enableb = false

	stage ('Prepare', true) {
		def functions = libraryResource 'local/suker200/functions.sh'
		writeFile file: 'functions.sh', text: functions
	    commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID").trim()
	    opsType = sh(returnStdout: true, script: ". ./functions.sh && getOpsType").trim()
	    actionType = sh(returnStdout: true, script: ". ./functions.sh && getActionType").trim()
	}

	if (opsType=='kops' && actionType=='destroy_cluster') {
		println ("destroy cluster okie")
	}

	if (enablea) {
		stage ('taskA') {
			println "okie taskA"
		}
	}

	if (enableb) {
		stage ('taskB') {
			println "okie taskB"
		}
	}

}
