#!groovy
import jenkins.model.*
import hudson.security.*

def env = System.getenv()

// parameters
def jenkinsParameters = [
  email:  'Jenkins Admin <admin@jenkins.com>',
  url:    'https://localhost:8443/'
]

// get Jenkins location configuration
def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

// set Jenkins URL
jenkinsLocationConfiguration.setUrl(jenkinsParameters.url)

// set Jenkins admin email address
jenkinsLocationConfiguration.setAdminAddress(jenkinsParameters.email)

// save current Jenkins state to disk
jenkinsLocationConfiguration.save()