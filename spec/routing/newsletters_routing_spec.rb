require "spec_helper"

describe NewslettersController do
  describe "routing" do
    it "routes to #index" do
      expect(get("/newsletters")).to route_to("newsletters#index")
    end

    it "routes to #new" do
      expect(get("/newsletters/new")).to route_to("newsletters#new")
    end

    it "routes to #show" do
      expect(get("/newsletters/1")).to route_to("newsletters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/newsletters/1/edit")).to route_to("newsletters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/newsletters")).to route_to("newsletters#create")
    end

    it "routes to #update" do
      expect(put("/newsletters/1")).to route_to("newsletters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/newsletters/1")).to route_to("newsletters#destroy", :id => "1")
    end
  end
end
