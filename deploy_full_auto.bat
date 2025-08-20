@echo off
REM =====================================================
REM Fully Automated Crypto Trading Project Deployment
REM One-Click: Auto Git, Branch, Commit, Env, Vercel Deploy
REM =====================================================

REM 1️⃣ Navigate to project folder
cd /d %~dp0

REM 2️⃣ Configure Git identity if not set
for /f "tokens=*" %%i in ('git config --global user.name') do set GIT_NAME=%%i
for /f "tokens=*" %%i in ('git config --global user.email') do set GIT_EMAIL=%%i

if "%GIT_NAME%"=="" (
    git config --global user.name "Louise Zamiel"
    echo Git global user.name set to Louise Zamiel
)
if "%GIT_EMAIL%"=="" (
    git config --global user.email "louisezamiel@gmail.com"
    echo Git global user.email set to louisezamiel@gmail.com
)

REM 3️⃣ Ensure main branch exists
git rev-parse --verify main >nul 2>&1
if errorlevel 1 (
    git checkout -b main
    echo Main branch created
) else (
    git checkout main
    echo Switched to main branch
)

REM 4️⃣ Update vercel.json with valid JSON
(
echo {
echo   "version": 2,
echo   "builds": [
echo     { "src": "package.json", "use": "@vercel/next" }
echo   ],
echo   "routes": [
echo     { "src": "/(.*)", "dest": "/" }
echo   ]
echo }
) > vercel.json
echo vercel.json updated successfully!
echo.

REM 5️⃣ Stage all changes
git add .

REM 6️⃣ Commit changes with auto-generated timestamp
for /f "tokens=1-4 delims=/: " %%a in ("%date% %time%") do (
    set DATETIME=%%a-%%b-%%c_%%d
)
git commit -m "Auto deploy commit %DATETIME%" >nul 2>&1

REM 7️⃣ Push to GitHub
git push -u origin main
echo.

REM 8️⃣ Set Vercel environment variables (pre-filled)
set SUPABASE_URL=your-supabase-url
set SUPABASE_ANON_KEY=your-anon-key
set MAYA_KEY=your-maya-secret-key

REM 8a️⃣ Skip env vars if they already exist
for %%V in (NEXT_PUBLIC_SUPABASE_URL NEXT_PUBLIC_SUPABASE_ANON_KEY MAYA_SECRET_KEY) do (
    vercel env ls | findstr /i "%%V" >nul
    if errorlevel 1 (
        REM Variable not found, add it
        if "%%V"=="NEXT_PUBLIC_SUPABASE_URL" vercel env add %%V production %SUPABASE_URL%
        if "%%V"=="NEXT_PUBLIC_SUPABASE_ANON_KEY" vercel env add %%V production %SUPABASE_ANON_KEY%
        if "%%V"=="MAYA_SECRET_KEY" vercel env add %%V production %MAYA_KEY%
        echo Added %%V
    ) else (
        echo %%V already exists, skipping...
    )
)
echo.

REM 9️⃣ Deploy to Vercel production
vercel --prod

echo.
echo =====================================================
echo Deployment complete! Visit your Vercel URL
echo =====================================================
pause