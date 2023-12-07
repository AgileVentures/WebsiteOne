require 'spec_helper'

describe "Subscription" do

  PlanAttributes = {
    "name" => "T-Shirt of the Month Club Plan",
    "description" => "Template creation.",
    "type" => "fixed",
    "payment_definitions" => [
        {
            "name" => "Regular Payments",
            "type" => "REGULAR",
            "frequency" => "MONTH",
            "frequency_interval" => "2",
            "amount" => {
                "value" => "100",
                "currency" => "USD"
            },
            "cycles" => "12",
            "charge_models" => [
                {
                    "type" => "SHIPPING",
                    "amount" => {
                        "value" => "10",
                        "currency" => "USD"
                    }
                },
                {
                    "type" => "TAX",
                    "amount" => {
                        "value" => "12",
                        "currency" => "USD"
                    }
                }
            ]
        }
    ],
    "merchant_preferences" => {
        "setup_fee" => {
            "value" => "1",
            "currency" => "USD"
        },
        "return_url" => "http://www.return.com",
        "cancel_url" => "http://www.cancel.com",
        "auto_bill_amount" => "YES",
        "initial_fail_amount_action" => "CONTINUE",
        "max_fail_attempts" => "0"
    }
  }

  AgreementAttributes = {
    "name" => "T-Shirt of the Month Club Agreement",
    "description" => "Agreement for T-Shirt of the Month Club Plan",
    "start_date" => "2015-02-19T00:37:04Z",
    "payer" => {
        "payment_method" => "paypal"
    },
    "shipping_address" => {
        "line1" => "111 First Street",
        "city" => "Saratoga",
        "state" => "CA",
        "postal_code" => "95070",
        "country_code" => "US"
    }
}

  describe "BillingPlan", :integration => true do
    it "Create" do
      # create access token and then create a plan
      $api = API.new
      plan = Plan.new(PlanAttributes.merge( :token => $api.token ))
      expect(Plan.api).not_to eql plan.api
      plan.create

      # make sure the transaction was successful
      $plan_id = plan.id
      expect(plan.error).to be_nil
      expect(plan.id).not_to be_nil
    end

    it "Update" do
      # create a new plan to update
      plan = Plan.new(PlanAttributes)
      expect(plan.create).to be_truthy

      # set up a patch request
      patch = Patch.new
      patch.op = "replace"
      patch.path = "/";
      patch.value = { :state => "ACTIVE" }

      # the patch request should be successful
      expect(plan.update( patch )).to be_truthy
    end

    it "List" do
      # list all billing plans
      plan_list = Plan.all
      expect(plan_list.error).to be_nil
      expect(plan_list.plans.count).to be > 1
    end

    it "Delete" do
      # create a plan to delete
      plan = Plan.new(PlanAttributes.merge( :token => $api.token ))
      plan.create
      plan_id = plan.id

      # construct a patch object that will be used for deletion
      patch = Patch.new
      patch.op = "replace"
      patch.path = "/"
      patch.value = { "state" => "DELETED" }

      # send delete request
      plan.update(patch)

      # make sure the plan has been deleted
      plan = Plan.find(plan_id)
      expect(plan.id).not_to eq plan_id
    end
  end

  describe "BillingAgreement", :integration => true do

    it "Create" do
      # first, create an active plan to be added to agreement
      api = API.new
      plan = Plan.new(PlanAttributes)
      expect(plan.create).to be_truthy

      # first, create an agreement
      $agreement = Agreement.new(AgreementAttributes)
      $agreement.plan = Plan.new( :id => "P-1K47639161110773GYDKTWIA" )
      $agreement.shipping_address = nil

      # verify newly created agreement
      expect($agreement.create).to be_truthy
      expect($agreement.id).to be_nil
      expect($agreement.token).not_to be_nil
      expect($agreement.name).to eq("T-Shirt of the Month Club Agreement")
    end

    #####################################
    # The following tests are disabled due to them requiring an active billing agreement or buyer's approval.
    # Most of them require an agreement ID, which is returned after executing agreement. 
    # And agreement execution requires buyer's approval.
    #####################################

    xit "Execute" do
      # Use this call to execute an agreement after the buyer approves it.
      expect($agreement.execute).to be_truthy
    end

    xit "Get" do
      # this call needs an agreement ID of the agreement to be retrieved
      agreement = Agreement.find($agreement.id)
      expect(agreement.id).to eq($agreement.id)
      expect(agreement.description).to eq("Agreement for T-Shirt of the Month Club Plan")
      expect(agreement.start_date).to eq("2015-02-19T00:37:04Z")
      expect(agreement.plan).not_to be_nil
    end

    xit "Update" do
      # get the agreement to update
      api = API.new
      plan = Plan.new(PlanAttributes)
      expect(plan.create).to be_truthy

      # first, create an agreement
      agreement = Agreement.new(AgreementAttributes)
      agreement.plan = Plan.new( :id => "P-1K47639161110773GYDKTWIA" )
      expect(agreement.create).to be_truthy


      # create an update for the agreement
      random_string = (0...8).map { (65 + rand(26)).chr }.join
      patch = Patch.new
      patch.op = "replace"
      patch.path = "/" 
      patch.value = { "description" => random_string }

      # send update request
      response = agreement.update(patch)

      # verify the agreement update was successful
      expect(response).to be_truthy
      updated_agreement = Agreement.get($agreement.id)
      expect(updated_agreement.id).to eq($agreement.id)
      expect(random_string).to eq(updated_agreement.description)
    end

    xit "Suspend" do
      # set the id of an active agreement here
      agreement_id = ""
      agreement = Agreement.find(agreement_id)

      state_descriptor = AgreementStateDescriptor.new( :note => "Suspending the agreement" )
      expect( agreement.suspend(state_descriptor) ).to be_truthy
    end

    xit "Reactivate" do
      # set the id of a suspended agreement here
      agreement_id = ""
      agreement = Agreement.find(agreement_id)

      state_descriptor = AgreementStateDescriptor.new( :note => "Re-activating the agreement" )
      expect( agreement.re_activate(state_descriptor) ).to be_truthy
    end

    xit "Search" do
      transactions = Agreement.transactions($agreement.id, "2015-01-01", "2015-01-10")
      expect(transactions).not_to be_nil
      expect(transactions.agreement_transaction_list).not_to be_empty
    end

    xit "Cancel" do
      # set the id of an agreement here
      agreement_id = ""
      agreement = Agreement.find(agreement_id)

      state_descriptor = AgreementStateDescriptor.new( :note => "Cancelling the agreement" )
      expect( agreement.cancel(state_descriptor) ).to be_truthy
    end

  end
end
