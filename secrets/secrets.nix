let
  viv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaLbeF/g1HPa/V+EtvGuhyPf3INccYLkfbDSGOZVVqM";
  users = [ viv ];

  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7aMubM1g+aIrlAPOOICEuoKki3jEycmGvgJ9z7HKUS";
  systems = [ laptop ];
in
{
  "password.age".publicKeys = [ viv laptop ];
  "github-oath.age".publicKeys = [ viv laptop ];
}
