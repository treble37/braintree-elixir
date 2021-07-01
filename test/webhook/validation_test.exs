defmodule Braintree.Webhook.ValidationTest do
  use ExUnit.Case, async: true

  alias Braintree.Webhook.Validation

  describe "Validation#validate_signature/2" do
    setup do
      payload =
        "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPG5vdGlm\naWNhdGlvbj4KICA8a2luZD5jaGVjazwva2luZD4KICA8dGltZXN0YW1wIHR5\ncGU9ImRhdGV0aW1lIj4yMDIxLTA2LTI0VDIzOjQxOjU4WjwvdGltZXN0YW1w\nPgogIDxzdWJqZWN0PgogICAgPGNoZWNrIHR5cGU9ImJvb2xlYW4iPnRydWU8\nL2NoZWNrPgogIDwvc3ViamVjdD4KPC9ub3RpZmljYXRpb24+Cg==\n"

      signature =
        "93jkrvc4dhwgggvb|18e3da6df975b51672fb66db8c17b6a587119cf4&bbqs7w3x5mxpn2kt|c4aeed13c841092f92a52c30f4102bcdc9f56b9e&d4wrnb8q3nth8c6z|787357b629927407c406371cce80d3e2b803b539&z5zy86h2g96wwk6y|deb53e0857b83c51dd47e7af000b629caf63d4ab"

      %{payload: payload, signature: signature}
    end

    test "returns :ok with valid signature and payload", %{payload: payload, signature: signature} do
      assert Validation.validate_signature(signature, payload) == :ok
    end

    test "returns error tuple with invalid signature", %{payload: payload} do
      assert Validation.validate_signature("fake_signature", payload) ==
               {:error, "No matching public key"}
    end

    test "returns error tuple with invalid payload", %{signature: signature} do
      assert Validation.validate_signature(signature, "fake_payload") ==
               {:error, "Signature does not match payload, one has been modified"}
    end

    test "returns error tuple with nil payload", %{signature: signature} do
      assert Validation.validate_signature(signature, nil) == {:error, "Payload cannot be nil"}
    end

    test "returns error tuple with nil signature", %{payload: payload} do
      assert Validation.validate_signature(nil, payload) == {:error, "Signature cannot be nil"}
    end
  end
end
