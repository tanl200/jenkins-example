@Library('github.com/tanl200/jenkins-pipeline-library') _
node {

	deleteDir()

	stage ('checkout') {
		checkout scm
	}
	
	def commit = ''
	def commitID = ''

	stage ('Load Function') {
		def functions = libraryResource 'local/suker200/functions.sh'
		writeFile file: 'functions.sh', text: functions
	}

	stage ('info') {
	    commitID = sh(returnStdout: true, script: ". ./functions.sh && getCommitID")
	    commit = sh(returnStdout: true, script: ". ./functions.sh && getCommitMessageAction")
	}

    stage ('kops-action') {
	    kops {
	    	action = "${commit}"
	    }    
    }

    stage ('kops-export') {
	    kops {
	    	action = "export"
	    }    
    }

	stage ('Approve') {
	    approve {
	    	message = 'Test stage completed, please approved for next step'
	    }	
	}

    stage ('commit message') {
	    gitops {
	    	user = 'tanl200'
	    	email = 'tanl200@home.local'
	    	commitMessage = "${commitID}"
	    }
    }
}
