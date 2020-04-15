class TransferService
    def self.call(from_user_id, to_user_id, amount)
      sendler = User.find(from_user_id)
      return false if sendler.balance < amount

      receiver = User.find(to_user_id)
      User.transaction do
        sendler.lock!
        receiver.lock!
        sendler.update!(balance: sendler.balance - amount)
        receiver.update!(balance: receiver.balance + amount)
      end
    end
end
