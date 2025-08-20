@echo off
REM =====================================================
REM Fully Automated Crypto Trading Project Deployment
REM Reads environment variables directly from .env.local
REM One-Click: Git, Branch, Commit, Push, Vercel Deploy
REM =====================================================

cd /d %~dp0

REM -----------------------------
REM 1️⃣ Configure Git identity if missing
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

REM -----------------------------
REM 2️⃣ Ensure main branch exists
git rev-parse --verify main >nul 2>&1
if errorlevel 1 (
    git checkout -b main
    echo Main branch created
) else (
    git checkout main
    echo Switched to main branch
)

REM -----------------------------
REM 3️⃣ Update vercel.json
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

REM -----------------------------
REM 4️⃣ Stage all changes
git add .

REM 5️⃣ Commit changes with date/time message
for /f "tokens=1-4 delims=/: " %%a in ("%date% %time%") do (
    set DATETIME=%%a-%%b-%%c_%%d
)
git commit -m "Auto deploy commit %DATETIME%" >nul 2>&1

REM -----------------------------
REM 6️⃣ Push to GitHub
git push -u origin main
echo.

REM -----------------------------
REM 7️⃣ Read .env.local for keys
for /f "usebackq tokens=1,2 delims==" %%A in (".env.local") do (
    set %%A=%%B
)

REM -----------------------------
REM 8️⃣ Add Vercel environment variables (skip if exists)
for %%V in (NEXT_PUBLIC_SUPABASE_URL NEXT_PUBLIC_SUPABASE_ANON_KEY MAYA_SECRET_KEY) do (
    vercel env ls | findstr /i "%%V" >nul
    if errorlevel 1 (
        REM Variable not found, add it
        if "%%V"=="NEXT_PUBLIC_SUPABASE_URL" vercel env add %%V production %NEXT_PUBLIC_SUPABASE_URL%
        if "%%V"=="NEXT_PUBLIC_SUPABASE_ANON_KEY" vercel env add %%V production %NEXT_PUBLIC_SUPABASE_ANON_KEY%
        if "%%V"=="MAYA_SECRET_KEY" vercel env add %%V production %MAYA_SECRET_KEY%
        echo Added %%V
    ) else (
        echo %%V already exists, skipping...
    )
)
echo.

REM -----------------------------
REM 9️⃣ Deploy to Vercel production
vercel --prod

echo.
echo =====================================================
echo Deployment complete! Visit your Vercel URL
echo =====================================================
pause