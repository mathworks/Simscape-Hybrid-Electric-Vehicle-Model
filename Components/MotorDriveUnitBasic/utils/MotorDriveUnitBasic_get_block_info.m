function info = MotorDriveUnitBasic_get_block_info(blk_gcbh)
% collects block parameter values from Motor Drive Unit block
% To use this function, make sure to select the motor block in Simulink canvas
% and then pass gcbh to this function.

% Copyright 2021 The MathWorks, Inc.

getp = @(p) evalin('base', get_param(blk_gcbh, p));

info.response_time_const_s = getp('response_time_const');
info.trq_max_Nm = getp('trq_max');
info.spd_max_rpm = getp('spd_max');
info.power_max_kW = getp('power_max');
info.efficiency_percent = getp('efficiency_pct');
info.speed_eff_rpm = getp('spd_eff');
info.torque_eff_Nm = getp('trq_eff');
info.iron_to_nominal_ratio = getp('iron_to_nominal_ratio');
info.elec_loss_const_W = getp('elec_loss_const');
info.k_damp_Nm_per_radPerS = getp('k_damp');
info.J_rotor_kg_m2 = getp('J_rotor');

end
