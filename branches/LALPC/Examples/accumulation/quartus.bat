set BENCH=accumulator.v
quartus_map top --source=%BENCH% --family="Cyclone IV GX"
quartus_fit top --part=EP4CGX150DF31C7
quartus_asm top
quartus_sta top
