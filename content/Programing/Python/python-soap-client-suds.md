---
title: "A Python SOAP client sample code"
date: 2017-09-11T13:37:20+08:00
tags: [ "Development" ]
categories: [ "Python" ]
draft: true
---

- suds API references
 - https://pypi.python.org/pypi/suds
 - https://fedorahosted.org/suds/wiki/Documentation


- example code

```
import logging
logging.basicConfig(level=logging.INFO)
logging.getLogger('suds.client').setLevel(logging.DEBUG)

username = ''
password = ''
no = 20787

def b64enc(username, password):
    import base64
    base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
    authenticationHeader = {"SOAPAction" : "ActionName", "Authorization" : "Basic %s" % base64string }
    return authenticationHeader

def xmlout(xmlstr):
    filename = '%s.xml' % no
    f = open(filename, "w")
    f.write(xmlstr.encode('utf8'))

def main():
    from suds.client import Client
    wsdl_url = 'http://example.com:6666/portal-ws/ws/PersonalService?wsdl'
    authenticationHeader = b64enc(username, password)
    client = Client(url=wsdl_url, headers=authenticationHeader, retxml=True)
    #list_methods_of_service = [method for method in client.wsdl.services[0].ports[0].methods]
    #using service.findByNo methods
    response = client.service.findByNo(no)
    xml = response.decode('utf8')
    print xml
    xmlout(xml)

if __name__ == '__main__':
    main()
```