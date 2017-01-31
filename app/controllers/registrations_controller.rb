class RegistrationsController < Devise::RegistrationsController
  def edit
    resource.user_treatments.build if resource.user_treatments.empty?
    resource.treatments.build if resource.treatments.empty?
    resource.children.build
    super
  end

  def update
    super
  end

	protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
