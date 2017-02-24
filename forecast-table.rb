
# Forecast Table Generator

require 'paint'
require 'terminal-table'
require_relative 'progress-bar-component'

# Questioner class
class ForecastQuestioner
  def initialize(questions)
    @questions = questions
    # Not taken as an argument because it is hard-coded
    @days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ]
  end

  attr_accessor :questions

  def insert_table(days, temp_c, temp_f)
    @days = days.join("\n")
    rows = []
    rows << [@days, temp_c, temp_f]
    table = Terminal::Table.new title: 'Weather Forecast', headings: ["Day", "Celsius", "Fahrenheit"], rows: rows
    puts table
  end

  def ask(progress_bar)
    answers = []
    temp_c = []
    temp_f = []

    @questions.each do |question|
      system('clear')
      puts "#{progress_bar.title}: #{progress_bar.current_step}/#{@questions.length}"
      puts question
      # Need integer validation so that user if user inputs a string,
      # error message displayed and question asked again
      answer = gets.chomp.to_i
      answers << answer
      progress_bar.current_step += 1
    end

    # Can this be separated into a separate method?
    answers.each do |answer|
      if answer <= 28
        temp_c << Paint[answer, :blue]
        temp_f << Paint[answer * 9 / 5 + 32, :blue]
      elsif answer >= 28
        temp_c << Paint[answer, :red]
        temp_f << Paint[answer * 9 / 5 + 32, :red]
      end
    end
    @temp_c = temp_c.join("\n")
    @temp_f = temp_f.join("\n")
    insert_table(@days, @temp_c, @temp_f)
  end
end # End questioner class

question_list = [
  'What was the temperature on Monday?',
  'What was the temperature on Tuesday?',
  'What was the temperature on Wednesday?',
  'What was the temperature on Thursday?',
  'What was the temperature on Friday?',
  'What was the temperature on Saturday?',
  'What was the temperature on Sunday?'
]

forecast_questioner = ForecastQuestioner.new(question_list)
progress_bar = ProgressBar.new('Question')

forecast_questioner.ask(progress_bar)
