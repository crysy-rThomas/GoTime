defmodule TimemanagerWeb.LoginJSON do


  def login(%{token: token, id: id}) do
    %{data: %{token: token, id: id}}
  end

  def error(%{error: error}) do
    %{data: %{error: error}}
  end
end
