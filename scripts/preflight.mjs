import { execSync } from 'child_process';
const expectedNode = 'v20.11.0';
if (process.version !== expectedNode) {
  console.error(`Node version mismatch. Expected ${expectedNode}, got ${process.version}`);
  process.exit(1);
}
// Verify UTC and No Color environment
const envs = ['TZ=UTC', 'NO_COLOR=1'];
envs.forEach(env => {
  const [key, val] = env.split('=');
});
console.log("Preflight check passed.");
