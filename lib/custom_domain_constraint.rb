class CustomDomainConstraint
  def self.matches? request
    request.subdomain.present? && matching_blog?(request)
  end

  def self.matching_blog? request
    Blog.where(:custom_domain => request.host).any?
  end
end
