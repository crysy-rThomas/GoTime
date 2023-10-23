defmodule TimemanagerWeb.PersonHTML do
  use TimemanagerWeb, :html

  embed_templates "person_html/*"

  @doc """
  Renders a person form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def person_form(assigns)
end
