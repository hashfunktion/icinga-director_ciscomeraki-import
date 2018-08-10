#!/usr/bin/env python
# coding: utf-8

#######################################################################################################################
#title           :Meraki_API-Export.py
#description     :This will call the Meraki Dashboard API and query all networks from the organisation for Meraki devices.
#                 Query results are writen into a json file for each network so the Icinga Director can import them.
#author          :Jesse Reppin
#date            :2018-08-10
#version         :1.1
#usage           :python Meraki_API-Export.py
#notes           :
#python_version  :3.6
#
#######################################################################################################################

#change for your settings

API_Key = "<API KEY" # Meraki Dashbaord API Key
smtpserver = "<MAIL SERVER>" #SMTP Server for mailing error notifications
smtpport = "25" #SMTP Port
fromaddr = "<MAIL ADDRESS>" #mail sender
toaddr = "<MAIL ADDRESS>" #mail reciever
filepath = "<EXPORT FILEPATH>" #json outputfilepath



################################
#                              #
##                            ##
### DO NOT CHANGE DOWN THIS! ###
##                            ##
#                              #
################################


#imports
import requests
import json
import smtplib
import traceback

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

#define vars
i = 0
parameters = {"X-Cisco-Meraki-API-Key": API_Key}
baseurl = "https://api.meraki.com/api/v0/"
e = ""
resp_org = ""
resp_networks = ""
resp_devices = ""

#define functions
def call_orgs():
    org_geturl = "{0}organizations".format(str(baseurl))
    return requests.get(org_geturl, headers=parameters)

def call_networks():
    network_geturl = "{0}organizations/{1}/networks".format(str(baseurl), str(org_id))
    return requests.get(network_geturl, headers=parameters)

def call_devices():
    device_geturl = "{0}networks/{1}/devices".format(str(baseurl), str(network_id))
    return requests.get(device_geturl, headers=parameters)

def error_mail():
    error_resp = "{0}{1}{2}".format(str(resp_org), str(resp_networks), str(resp_devices))
    msg = MIMEMultipart()
    msg['From'] = fromaddr
    msg['To'] = toaddr
    msg['Subject'] = "Export Error {0} - Meraki API".format(str(error_resp))
    body = "\n {0} \n \n \n Status and Error Codes \n 400: Bad Request- You did something wrong, e.g. a malformed request or missing parameter.\n 403: Forbidden- You don't have permission to do that. \n 404: Not found- No such URL, or you don't have access to the API or organization at all.".format(str(error_resp))
    msg.attach(MIMEText(body, 'plain'))
    server = smtplib.SMTP(smtpserver, smtpport)
#   server.starttls()
#   server.login(fromaddr, "YOUR PASSWORD")
    text = msg.as_string()
    server.sendmail(fromaddr, toaddr, text)
    server.quit()

def exception_mail():
    msg = MIMEMultipart()
    msg['From'] = fromaddr
    msg['To'] = toaddr
    msg['Subject'] = "Python Export Exception"
    body = "\n {0} \n \n Please take look at the Script.".format(errormessage)
    msg.attach(MIMEText(body, 'plain'))
    server = smtplib.SMTP(smtpserver, smtpport)
#   server.starttls()
#   server.login(fromaddr, "YOUR PASSWORD")
    text = msg.as_string()
    server.sendmail(fromaddr, toaddr, text)
    server.quit()

#execute export via API
try:
    #API Call for Orgs that have access with the API-Key
    resp_org = call_orgs()
    if resp_org.status_code == requests.codes.ok:
        org = resp_org.json()
        org_id = org[0][u'id']
        
        #API call for networs in org
        resp_networks = call_networks()
        if resp_networks.status_code == requests.codes.ok:
            networks = resp_networks.json()
            while i < len(networks):
                network_id = (networks[i][u'id'])
                network_name = (networks[i][u'name'])
                
                #API call for devices in all networks
                resp_devices = call_devices()
                if resp_devices.status_code == requests.codes.ok:
                    devices = resp_devices.json()
                    filename = "{0}MerakiEXPORT-{1}.json".format(str(filepath), str(network_name)) 
                    with open(filename, 'w') as outfile:
                        json.dump(devices, outfile)
                    i += 1
                
                #http error handling
                elif resp_devices.status_code != requests.codes.ok:
                    error_mail()
        
        #http error handling
        elif resp_networks.status_code != requests.codes.ok:
            error_mail()

    #http error handling
    elif resp_org.status_code != requests.codes.ok:
        error_mail()

#exeption handling
except Exception:
    # Get traceback as a string and do something with it
    tracebackmessage = str(traceback.format_exc())
    errormessage = "Something went wrong! Error Code: \n \n {0}".format(tracebackmessage)
    print(errormessage) #print exception in cli
    exception_mail() #send exception via mail