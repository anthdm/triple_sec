defmodule Scryptex.Pbkdf2Test do
  use ExUnit.Case, async: true
  alias Scryptex.Pbkdf2

  defp check_vectors(list, iterations, length, prf) do
    Enum.each(list, fn {password, salt, hash} ->
      assert Pbkdf2.pbkdf2(password, salt, iterations, length, prf) == hash
    end)
  end

  test "base" do
    assert Pbkdf2.pbkdf2("password", "0123456789abcdef", 1, 32, &:crypto.hmac(:sha512, &1, &2)) ==
             <<193, 61, 90, 136, 113, 11, 206, 56, 158, 69, 39, 50, 130, 177, 251, 11, 214, 1,
               121, 42, 250, 241, 56, 122, 129, 140, 143, 82, 213, 101, 185, 92>>

    assert Pbkdf2.pbkdf2("password", "0123456789abcdef", 2, 32, &:crypto.hmac(:sha512, &1, &2)) ==
             <<186, 98, 237, 134, 129, 9, 190, 135, 251, 15, 165, 175, 31, 49, 183, 11, 201, 34,
               80, 250, 161, 58, 110, 166, 250, 81, 210, 141, 110, 64, 128, 219>>
  end

  test "base pbkdf2_sha512" do
    [
      {"passDATAb00AB7YxDTT", "saltKEYbcTcXHCBxtjD",
       <<172, 205, 205, 135, 152, 174, 92, 216, 88, 4, 115, 144, 21, 239, 42, 17, 227, 37, 145,
         183, 183, 209, 111, 118, 129, 155, 48, 176, 212, 157, 128, 225, 171, 234, 108, 152, 34,
         184, 10, 31, 223, 228, 33, 226, 111, 86, 3, 236, 168, 164, 122, 100, 201, 160, 4, 251,
         90, 248, 34, 159, 118, 47, 244, 31>>},
      {"passDATAb00AB7YxDTTl", "saltKEYbcTcXHCBxtjD2",
       <<89, 66, 86, 176, 189, 77, 108, 159, 33, 168, 127, 123, 165, 119, 42, 121, 26, 16, 230,
         17, 6, 148, 244, 67, 101, 205, 148, 103, 14, 87, 241, 174, 205, 121, 126, 241, 209, 0,
         25, 56, 113, 144, 68, 199, 240, 24, 2, 102, 151, 132, 94, 185, 173, 151, 217, 125, 227,
         106, 184, 120, 106, 171, 80, 150>>},
      {"passDATAb00AB7YxDTTlRH2dqxDx19GDxDV1zFMz7E6QVqKIzwOtMnlxQLttpE5",
       "saltKEYbcTcXHCBxtjD2PnBh44AIQ6XUOCESOhXpEp3HrcGMwbjzQKMSaf63IJe",
       <<7, 68, 116, 1, 200, 87, 102, 228, 174, 213, 131, 222, 46, 107, 245, 166, 117, 234, 190,
         79, 54, 24, 40, 28, 149, 97, 111, 79, 193, 253, 254, 110, 203, 193, 195, 152, 39, 137,
         212, 253, 148, 29, 101, 132, 239, 83, 74, 120, 189, 55, 174, 2, 85, 93, 148, 85, 232,
         240, 137, 253, 180, 223, 182, 187>>}
    ]
    |> check_vectors(100_000, 64, &:crypto.hmac(:sha512, &1, &2))
  end

  test "python passlib pbkdf2_sha512" do
    [
      {"password", <<36, 196, 248, 159, 51, 166, 84, 170, 213, 250, 159, 211, 154, 83, 10, 193>>,
       <<140, 166, 217, 30, 131, 240, 81, 96, 83, 211, 202, 99, 111, 240, 167, 81, 153, 133, 112,
         31, 73, 91, 135, 108, 59, 53, 100, 126, 47, 87, 232, 247, 103, 228, 213, 214, 121, 143,
         166, 132, 189, 65, 155, 133, 125, 174, 54, 11, 229, 151, 192, 223, 107, 161, 236, 105,
         118, 130, 222, 88, 65, 175, 201, 8>>},
      {"p@$$w0rd", <<252, 159, 83, 202, 89, 107, 141, 17, 66, 200, 121, 239, 29, 163, 20, 34>>,
       <<0, 157, 195, 175, 221, 186, 150, 210, 181, 176, 230, 76, 100, 0, 40, 79, 177, 40, 71,
         180, 127, 30, 159, 134, 232, 27, 126, 224, 49, 68, 54, 38, 26, 202, 21, 76, 253, 144, 79,
         186, 168, 197, 54, 23, 4, 244, 216, 211, 153, 199, 147, 152, 185, 210, 171, 55, 196, 67,
         201, 154, 127, 46, 61, 179>>},
      {"oh this is hard 2 guess",
       <<1, 96, 140, 17, 162, 84, 42, 165, 84, 42, 165, 244, 62, 71, 136, 177>>,
       <<23, 76, 100, 204, 149, 14, 41, 161, 252, 167, 0, 31, 19, 2, 222, 100, 173, 191, 150, 46,
         130, 23, 120, 132, 114, 151, 232, 39, 85, 232, 19, 20, 20, 77, 43, 87, 8, 213, 113, 19,
         91, 29, 214, 77, 26, 121, 9, 82, 20, 174, 137, 159, 18, 78, 140, 205, 124, 145, 146, 29,
         204, 214, 36, 113>>},
      {"even more difficult",
       <<215, 186, 87, 42, 133, 112, 14, 1, 160, 52, 38, 100, 44, 229, 92, 203>>,
       <<76, 75, 253, 194, 132, 154, 85, 59, 24, 28, 188, 87, 156, 86, 214, 59, 90, 10, 173, 65,
         159, 80, 9, 99, 144, 185, 234, 143, 197, 191, 243, 64, 70, 104, 86, 225, 113, 193, 188,
         7, 215, 217, 115, 78, 81, 161, 74, 59, 37, 11, 223, 115, 11, 13, 121, 237, 125, 131, 193,
         131, 229, 76, 112, 28>>}
    ]
    |> check_vectors(19_000, 64, &:crypto.hmac(:sha512, &1, &2))
  end
end
