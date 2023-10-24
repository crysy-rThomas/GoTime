defmodule Timemanager.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
<<<<<<< HEAD
=======
        status: "some status",
        title: "some title"
      })
      |> Timemanager.Tasks.create_task()

    task
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
        status: 42,
        title: "some title"
      })
      |> Timemanager.Tasks.create_task()

    task
  end
<<<<<<< HEAD
=======

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Timemanager.Tasks.create_task()

    task
  end
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
end
