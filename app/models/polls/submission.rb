module Polls
  class Submission
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Naming

    attr_reader :questions

    validate :required_answers_validations

    def self.for(poll, user)
      new poll, user
    end

    def initialize(poll, user, hash = {})
      @poll      = poll
      @user      = user
      @hash      = hash
      @questions = poll.blueprint.map { |hash| Question::Line.new hash.with_indifferent_access }
    end

    def persisted?
      false
    end

    def update(hash = {})
      @hash = @hash.merge hash

      if valid?
        PollAnswer.create! do |poll_answer|
          poll_answer.user = @user
          poll_answer.poll = @poll
          poll_answer.answers = @hash
        end

        true
      end
    end

    def respond_to?(name, include_private = false)
      super or @questions.any? { |q| q.name == name.to_s }
    end

    def method_missing(name, *args, &block)
      question = @questions.detect { |q| q.name == name.to_s }

      if question
        question.value @hash[name.to_s]
      else
        super
      end
    end

    private

    def required_answers_validations
      @questions.select(&:required?).each do |question|
        value = question.value @hash[question.name]
        errors.add question.name, :presence if value.blank?
      end
    end
  end
end