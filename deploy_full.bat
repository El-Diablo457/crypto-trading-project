@echo off
REM =====================================================
REM Enhanced Crypto Trading Project Deployment Script
REM =====================================================

REM 1️⃣ Navigate to project folder
cd /d %~dp0

REM 2️⃣ Git status
git status

REM 3️⃣ Stage all changes
git add .

REM 4️⃣ Commit changes
set /p COMMIT_MSG=Enter commit message: 
git commit -m "%COMMIT_MSG%"

REM 5️⃣ Push to GitHub
git push origin main

REM 6️⃣ Set Vercel environment variables (prompt)
echo.
echo ===== Vercel Environment Variables =====
set /p SUPABASE_URL=Enter NEXT_PUBLIC_SUPABASE_URL: 
set /p SUPABASE_ANON_KEY=Enter NEXT_PUBLIC_SUPABASE_ANON_KEY: 
set /p MAYA_KEY=Enter MAYA_SECRET_KEY: 

vercel env add NEXT_PUBLIC_SUPABASE_URL production %SUPABASE_URL%
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production %SUPABASE_ANON_KEY%
vercel env add MAYA_SECRET_KEY production %MAYA_KEY%

REM 7️⃣ Deploy to Vercel production
vercel --prod

echo.
echo ===========================================
echo Deployment finished! Visit your Vercel URL
echo ===========================================
pause
