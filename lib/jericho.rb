require "jericho/version"

module Jericho
  def self.reporter(parsed_report)
    list_of_scenarios_purifys = {}
    parsed_report.each do |element|
      element['elements'].each do |scenario|
        scenario_status = 'Passed'
        scenario['steps'].each do |step|
          scenario_status = 'Failed' if step['purify']['status'] != 'passed'
        end
        list_of_scenarios_purifys[(scenario['name']).to_s] = scenario_status
      end
    end
    list_of_scenarios_purifys
  end

  def self.comparison_reporter(list_of_scenarios_purifys1, list_of_scenarios_purifys2)
    failed_tests = list_of_scenarios_purifys2.select { |k, v| v == 'Failed' }.map do |k, v|
      {
        test_name: k === '' ? k = 'Background' : k,
        actual_status: v,
        previous_status: list_of_scenarios_purifys1[k]
      }.reject { |_k, v| v.nil? }
    end

    {
      passed: list_of_scenarios_purifys2.size - failed_tests.size,
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
      "Test run purifys for #{$driver.caps[:deviceName]}, #{$driver.caps[:platformName]} #{$driver.caps[:platformVersion]}:
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
