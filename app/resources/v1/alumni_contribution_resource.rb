class V1::AlumniContributionResource < V1::ApplicationResource
  attributes :sponsoring_amount, :help_digtus, :help_kring, :help_vereniging, :help_anders

  has_one :user, always_include_linkage_data: true

  def self.creatable_fields(_context)
    %i[sponsoring_amount help_digtus help_kring help_vereniging help_anders]
  end

  def self.updatable_fields(_context)
    %i[sponsoring_amount help_digtus help_kring help_vereniging help_anders]
  end
end
