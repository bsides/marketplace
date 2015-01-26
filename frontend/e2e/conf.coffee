exports.config =
  allScriptsTimeout: 11000
  seleniumAddress: 'http://localhost:4444/wd/hub'
  capabilities:
    browserName: 'chrome'

  onPrepare: ->
    browser.driver.manage().window().setSize 1200, 800
    global.By = global.by
    return

  jasmineNodeOpts:
    showColors: true
    defaultTimeoutInterval: 30000
    includeStackTrace: true
    isVerbose: true

  specs: ['spec.coffee']

  params:
    login:
      user: 'leandro.lages@predicta.net'
      pass: 'fa0gc5'

  # folderName = (new Date()).toString().split(" ").splice(1, 4).join(" ")
  # mkdirp = require("mkdirp")
  # newFolder = "./reports/" + folderName
  # require "jasmine-reporters"
  # mkdirp newFolder, (err) ->
  #   if err
  #     console.error err
  #   else
  #     jasmine.getEnv().addReporter new jasmine.JUnitXmlReporter(newFolder, true, true)
  #   return

  # return
