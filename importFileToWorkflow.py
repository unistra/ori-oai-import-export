#-*- coding: utf-8 -*-
"""
Script to import notices into ori-oai-workflow by soap
"""
from suds.client import Client
from xml.dom.minidom import parse, parseString
import sys
from configparser import SafeConfigParser

# Check args
if len(sys.argv) != 3:
	sys.exit("Usage: python3 importFileToWorkflow.py config_type.ini filedc.xml")


# Get config variables
parser = SafeConfigParser()
parser.read(sys.argv[1])
url = parser.get('workflow', 'WORKFLOW_URL')
namespace = parser.get('workflow', 'WORKFLOW_NAMESPACE')
user = parser.get('workflow', 'WORKFLOW_USER')


filedc = str(sys.argv[2])

try:
    print ("Import " + filedc + " ...")
    
    number = 0
    
    #Create soap client
    client = Client(url)

    # Parse file with dom
    dom = parse(filedc)
    
    # If the file have multiples notices
    if dom.getElementsByTagName('oai_dc:dcCollection'):
        # for each notice
        for node in dom.getElementsByTagName('oai_dc:dc'):
            # Add notice header
            node.setAttribute('xmlns:oai_dc','http://www.openarchives.org/OAI/2.0/oai_dc/')
            node.setAttribute('xmlns:dc','http://purl.org/dc/elements/1.1/')
            # Create notice
            notice = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + node.toxml()
            #Import file into workflow
            idfiche = client.service.newWorkflowInstance(in0=notice, in1=namespace, in2=user)
            number = number + 1
    # one notice
    else:
        notice = dom.toxml()
        #Import file into workflow
        idfiche = client.service.newWorkflowInstance(in0=notice, in1=namespace, in2=user)
        number = 1
    
    print ("Done! " + str(number) + " notice(s) imported")
except:
    print ("Error during import... " + str(number) + " notice(s) imported")
    raise
