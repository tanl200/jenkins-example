@Library('github.com/tanl200/jenkins-pipeline-library') _
node {

	deleteDir()

	stage ('checkout') {
		checkout scm
	}
	
	def commit = ''
	def commitID = ''

    stage ('kops') {
	    kops {
	    	action = "${commit}"
	    }    
    }

    stage ('kops') {
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
	    sh(returnStdout: true, script: "git log --format=%s%b -n 1 \$(git rev-parse HEAD)  > commit.log")
	    commitID = sh(returnStdout: true, script: "git rev-parse HEAD")
	    commit = readFile('commit.log').split(":")[0]
	    gitops{
	    	user = 'tanl200'
	    	email = 'tanl200@home.local'
	    	branch = '${BUILD_NUMBER}'
	    	commitMessage = '${commitID}'
	    }
    }

}
