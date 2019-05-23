require "jericho/version"

module Jericho
  def self.reporter(parsed_report)
    list_of_scenarios_reports = {}
    parsed_report.each do |element|
      element['elements'].each do |scenario|
        scenario_status = 'Passed'
        scenario['steps'].each do |step|
          scenario_status = 'Failed' if step['result']['status'] != 'passed'
        end
        list_of_scenarios_reports[(scenario['name']).to_s] = scenario_status
      end
    end
    list_of_scenarios_reports
  end

  def self.get_jenkins_job_name
    name = ''
    file = File.open('logfile.txt')
    file.map {|line| name += line}
    return name.chomp
  end

  def self.comparison_reporter(list_of_scenarios_reports1, list_of_scenarios_reports2)
    failed_tests = list_of_scenarios_reports2.select { |k, v| v == 'Failed' }.map do |k, v|
      {
        test_name: k === '' ? k = 'Background' : k,
        actual_status: v,
        previous_status: list_of_scenarios_reports1[k]
      }.reject { |_k, v| v.nil? }
    end

    {
      passed: list_of_scenarios_reports2.size - failed_tests.size,
      failed: failed_tests.size,
      failed_tests: failed_tests
    }
  end

  def self.purify
    arr = Dir['*.json'].sort!
    arr.length <= 1 ? parsed_report1 = {} : parsed_report1 = JSON.parse(File.read(arr[-2]))
    parsed_report2 = JSON.parse(File.read(arr.last))
    purify = comparison_reporter(reporter(parsed_report1), reporter(parsed_report2))
  end

  def self.repent
    client = Slack::Web::Client.new
    client.chat_postMessage(
      channel: '#autotests',
      text:
      "Test run results for #{get_jenkins_job_name} #{$driver.caps[:deviceName]}, #{$driver.caps[:platformName]} #{$driver.caps[:platformVersion]}:
      Passed tests count: #{purify[:passed]},
      Failed tests count: #{purify[:failed]},",
      attachments: [
        {
         text: "*Failed tests*:
#{'Test name and previous status:' + ("\n") + purify[:failed_tests].map { |t| t.values_at(:test_name, :previous_status) }.join("\n") }
          ",
        color: 'danger'
      }
      ],
      mrkdwn: true,
      as_user: true,
    )
  end
end
