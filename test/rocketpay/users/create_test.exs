defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "whem all params are valid, return an user" do
      params = %{
        name: "Irineu",
        password: "123456",
        nickname: "iri",
        email: "irineu@gmail.com",
        age: 44
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Irineu", age: 44, id: ^user_id} = user
    end

    test "whem there are invalid params, return an error" do
      params = %{
        name: "Irineu",
        password: "12345",
        nickname: "iri",
        email: "irineu@gmail.com",
        age: 12
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)", "should be at least 6 character(s)"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
