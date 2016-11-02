import unittest
import os
from os.path import abspath
from appium import webdriver
from time import sleep
import logging
from appium.webdriver.common.touch_action import TouchAction

class  AppiumTests(unittest.TestCase):

    def setUp(self):
        desired_caps = {}
        desired_caps['platformName'] = 'iOS'
        desired_caps['platformVersion'] = '9.3' 
        desired_caps['deviceName'] = 'iPad Air'
        
        desired_caps['app'] = abspath('/Users/openly/Downloads/SS17.ipa')
        desired_caps['appiumVersion'] = '1.4.13'
        self.driver = webdriver.Remote('http://127.0.0.1:4723/wd/hub', desired_caps)
        

    def tearDown(self):
        self.driver.quit()

    def testCase1(self):
        print "\n------------------------------------"
        print "Both email and password exists and are correct"
        self.driver.implicitly_wait(120)
        # try:
        #   # email = self.driver.find_element_by_name('email')
        #   # email.set_value('demo1')
        #   # password = self.driver.find_element_by_name('pass')
        #   # password.set_value('test')
        #   # self.driver.find_element_by_name('LOGIN').click()
        #   # try:
        #   #   self.driver.find_element_by_name('GLOBAL')
        #   # except Exception, e:
        #   #   self.fail("Login Failed");
          
        # except Exception, e:
        #     print e


if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(AppiumTests)
    unittest.TextTestRunner(verbosity=2).run(suite)