---
title: "Python Web Automation Test"
date: 2017-09-11T13:40:40+08:00
draft: true
---

## Requirements
- Python
- Selenium
- webdriver
- HTMLTestRunner

## Sample code, test login to bugtracker and create html report
```
from selenium import webdriver
import unittest
import time
import HTMLTestRunner
class test_class(unittest.TestCase):
def setUp(self):
self.verificationErrors=[]
self.test=webdriver.Ie()
self.url="http://your.bugtracker.com/bug/"
def test_login(self):
pa=self.test
pa.get(self.url)
user=pa.find_element_by_id('username')
user.send_keys('使用者帳號')
passwd=pa.find_element_by_id('password')
passwd.send_keys('密碼')
pa.execute_script('loginsubmit()')
time.sleep(10)
def tearDown(self):
pass
if __name__=="__main__":
testsuite=unittest.TestSuite()
testsuite.addTest(test_class("test_login"))

filename="r:\\result.html"
fp=file(filename,'wb')
runner=HTMLTestRunner.HTMLTestRunner(stream=fp,title='Result',description='Test_Report')
runner.run(testsuite)
```