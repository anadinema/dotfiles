"use strict";var i=Object.defineProperty;var y=Object.getOwnPropertyDescriptor;var l=Object.getOwnPropertyNames;var d=Object.prototype.hasOwnProperty;var p=(t,e)=>{for(var n in e)i(t,n,{get:e[n],enumerable:!0})},g=(t,e,n,u)=>{if(e&&typeof e=="object"||typeof e=="function")for(let r of l(e))!d.call(t,r)&&r!==n&&i(t,r,{get:()=>e[r],enumerable:!(u=y(e,r))||u.enumerable});return t};var m=t=>g(i({},"__esModule",{value:!0}),t);var b={};p(b,{default:()=>w});module.exports=m(b);var a=require("@raycast/api"),s=require("node:child_process");async function c(t,e,n){e&&await(0,a.showHUD)(e),await D({menubar:!1,status:!1}),(0,s.exec)(`/usr/bin/caffeinate ${S(n)} || true`),await f(t,!0)}async function D(t,e){e&&await(0,a.showHUD)(e),(0,s.execSync)("/usr/bin/killall caffeinate || true"),await f(t,!1)}async function f(t,e){t.menubar&&await o("index",{caffeinated:e}),t.status&&await o("status",{caffeinated:e})}async function o(t,e){try{await(0,a.launchCommand)({name:t,type:a.LaunchType.Background,context:e})}catch{}}function S(t){let e=(0,a.getPreferenceValues)(),n=[];return e.preventDisplay&&n.push("d"),e.preventDisk&&n.push("m"),e.preventSystem&&n.push("i"),t&&n.push(` ${t}`),n.length>0?`-${n.join("")}`:""}async function w(){return await c({menubar:!0,status:!0},void 0,""),"Mac will stay awake until you manually disable it"}
