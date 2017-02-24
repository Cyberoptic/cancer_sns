require 'rails_helper'

RSpec.describe NotifiableSlackJob, type: :job do
  describe "#perform" do
    it "sends a Slack message" do      
      allow(Slack).to receive(:chat_postMessage).and_return(true)

      NotifiableSlackJob.perform_now(text: "Hi", channel: "test")

      expect(Slack).to have_received(:chat_postMessage)
    end
  end
end
