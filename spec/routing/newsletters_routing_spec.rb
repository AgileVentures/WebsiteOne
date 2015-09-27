require "spec_helper"

describe NewslettersController do
  describe "routing" do
    it "routes to #index" do
      get("/newsletters").should route_to("newsletters#index")
    end

    it "routes to #new" do
      get("/newsletters/new").should route_to("newsletters#new")
    end

    it "routes to #show" do
      get("/newsletters/1").should route_to("newsletters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/newsletters/1/edit").should route_to("newsletters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/newsletters").should route_to("newsletters#create")
    end

    it "routes to #update" do
      put("/newsletters/1").should route_to("newsletters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/newsletters/1").should route_to("newsletters#destroy", :id => "1")
    end
  end
end
