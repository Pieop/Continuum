hook.Add("Think", "NoRecoil", function()
    if LocalPlayer() and LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon().Primary then
        LocalPlayer():GetActiveWeapon().Primary.Recoil = 0
    end
end )