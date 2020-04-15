require 'rails_helper'

RSpec.describe TransferService do

  context '#call' do
  	subject(:service) { described_class }
  	let(:sendler) { create(:user, balance: 500) }
  	let(:receiver) { create(:user, balance: 200) }

    describe 'when balance is correct' do
      it 'make transfer' do
        service.call(sendler.id, receiver.id, 100)
        expect(User.find(sendler.id).balance).to eq(400)
        expect(User.find(receiver.id).balance).to eq(300)
      end
    end

    describe 'when balance is incorrect' do
      it 'returns falce' do
        expect(service.call(sendler.id, receiver.id, 600)).to eq(false)
      end
    end

    describe 'when service call in multiple threads' do
      let(:sendler_thread) { create(:user, balance: 200) }
      let(:receiver_thread) { create(:user, balance: 200) }

      it 'make transfer' do
        (0..2).map { Thread.new { service.call(sendler_thread.id, receiver_thread.id, 10) } }.each(&:join)
        
        expect(User.find(sendler_thread.id).balance).to eq(170)
        expect(User.find(receiver_thread.id).balance).to eq(230)
      end
    end
  end
end