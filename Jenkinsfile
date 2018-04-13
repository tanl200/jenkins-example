@Library('github.com/tanl200/jenkins-pipeline-library') _
def stageC(name, enable) {
	if (enable) {
		return stage(name)
	}
}

node {

	deleteDir()

	stage ('checkout') {
		checkout scm
	}
	
	def commitID = ''
	def opsType = ''
	def kopsEnable = false
	def terraformEnable = false

	stage ('Prepare') {
		def functions = libraryResource 'local/suker200/functions.sh'
		writeFile file: 'functions.sh', text: functions
	    commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID")
	    opsType = sh(returnStdout: true, script: ". ./functions.sh && getOpsType").trim()
	}



	if (opsType=="kops") {
		kopsEnable = true
	}

    stage ('Kops', kopsEnable) {
	    sh(returnStdout: true, script: ". ./functions.sh && prepareKops")
	    sh(returnStdout: true, script: ". ./functions.sh && runKops")

	    approve {
	    	message = 'Kops stage completed, please approved for next step'
	    }    
    }

}
