@Library('github.com/tanl200/jenkins-pipeline-library') _
node {

	deleteDir()

	stage ('checkout') {
		checkout scm
	}
	
	def commitID = ''
	def opsType = ''

	stage ('Prepare') {
		def functions = libraryResource 'local/suker200/functions.sh'
		writeFile file: 'functions.sh', text: functions
	    commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID")
	    opsType = sh(returnStdout: true, script: ". ./functions.sh && getOpsType")
	}

	stage ('test') {
		sh("echo ${opsType}")
	}
	
	if ("${opsType}"=='kops') {
	    stage ('Kops') {
		    sh(returnStdout: true, script: ". ./functions.sh && prepareKops")
		    sh(returnStdout: true, script: ". ./functions.sh && runKops")

		    approve {
		    	message = 'Kops stage completed, please approved for next step'
		    }
	    }	
    }
}
