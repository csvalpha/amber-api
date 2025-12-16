# frozen_string_literal: true

class V1::MailAliasesController < V1::ApplicationController
  include GraphitiCrud

  graphiti_resource V1::MailAliasResource
end
