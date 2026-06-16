# frozen_string_literal: true

module V1::Debit
  class MandatesController < V1::ApplicationController
    include GraphitiCrud

    graphiti_resource V1::Debit::MandateResource
  end
end
