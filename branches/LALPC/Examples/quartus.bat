for /f %%f in ('dir /b /ad') do (
  cd %%f
  quartus.bat
  cd ..
)