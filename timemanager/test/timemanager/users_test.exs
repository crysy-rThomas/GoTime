defmodule Timemanager.UsersTest do
  use Timemanager.DataCase

  alias Timemanager.Users

  describe "users" do
    alias Timemanager.Users.User

    import Timemanager.UsersFixtures
    import Timemanager.RolesFixtures

    @invalid_attrs %{password: nil, firstname: nil, lastname: nil, email: nil, role: nil}



    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user(user.id) == {:ok,user}
    end

    test "create_user/1 with valid data creates a user" do
      role = role_fixture()
      valid_attrs = %{password: "some password", firstname: "some firstname", lastname: "some lastname", email: "some email", role: role.id}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.firstname == "some firstname"
      assert user.lastname == "some lastname"
      assert user.email == "some email"
      assert user.role == role.id
      assert Bcrypt.verify_pass("some password", user.password ) == true
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      role = role_fixture()
      update_attrs = %{password: "some updated password", firstname: "some updated firstname", lastname: "some updated lastname", email: "some updated email",role: role.id}
      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.firstname == "some updated firstname"
      assert user.lastname == "some updated lastname"
      assert user.email == "some updated email"
      assert user.role == role.id
      assert Bcrypt.verify_pass("some updated password", user.password ) == true
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert {:ok,user} == Users.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
