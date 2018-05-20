defmodule WalletWeb.ErrorView do
  use WalletWeb, :view

  def render("400.json", assigns) do
    %{error: %{detail: assigns.reason.message}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{error: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
