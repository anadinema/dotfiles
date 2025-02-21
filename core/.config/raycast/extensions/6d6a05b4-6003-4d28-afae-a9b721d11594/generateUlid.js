"use strict";var L=Object.create;var h=Object.defineProperty;var O=Object.getOwnPropertyDescriptor;var M=Object.getOwnPropertyNames;var S=Object.getPrototypeOf,H=Object.prototype.hasOwnProperty;var R=(e,t)=>{for(var r in t)h(e,r,{get:t[r],enumerable:!0})},E=(e,t,r,n)=>{if(t&&typeof t=="object"||typeof t=="function")for(let o of M(t))!H.call(e,o)&&o!==r&&h(e,o,{get:()=>t[o],enumerable:!(n=O(t,o))||n.enumerable});return e};var A=(e,t,r)=>(r=e!=null?L(S(e)):{},E(t||!e||!e.__esModule?h(r,"default",{value:e,enumerable:!0}):r,e)),$=e=>E(h({},"__esModule",{value:!0}),e);var Y={};R(Y,{default:()=>X});module.exports=$(Y);var a=require("@raycast/api");var y=A(require("node:crypto"),1);function p(e){if(!l(e))throw new Error("Parameter was not an error")}function l(e){return P(e)==="[object Error]"||e instanceof Error}function P(e){return Object.prototype.toString.call(e)}function I(e){let t,r="";if(e.length===0)t={};else if(l(e[0]))t={cause:e[0]},r=e.slice(1).join(" ")||"";else if(e[0]&&typeof e[0]=="object")t=Object.assign({},e[0]),r=e.slice(1).join(" ")||"";else if(typeof e[0]=="string")t={},r=r=e.join(" ")||"";else throw new Error("Invalid arguments passed to Layerr");return{options:t,shortMessage:r}}var c=class e extends Error{constructor(t,r){let n=[...arguments],{options:o,shortMessage:s}=I(n),i=s;if(o.cause&&(i=`${i}: ${o.cause.message}`),super(i),this.message=i,o.name&&typeof o.name=="string"?this.name=o.name:this.name="Layerr",o.cause&&Object.defineProperty(this,"_cause",{value:o.cause}),Object.defineProperty(this,"_info",{value:{}}),o.info&&typeof o.info=="object"&&Object.assign(this._info,o.info),Error.captureStackTrace){let m=o.constructorOpt||this.constructor;Error.captureStackTrace(this,m)}}static cause(t){return p(t),t._cause&&l(t._cause)?t._cause:null}static fullStack(t){p(t);let r=e.cause(t);return r?`${t.stack}
caused by: ${e.fullStack(r)}`:t.stack}static info(t){p(t);let r={},n=e.cause(t);return n&&Object.assign(r,e.info(n)),t._info&&Object.assign(r,t._info),r}cause(){return e.cause(this)}toString(){let t=this.name||this.constructor.name||this.constructor.prototype.name;return this.message&&(t=`${t}: ${this.message}`),t}};var g="0123456789ABCDEFGHJKMNPQRSTVWXYZ",d=32,w=0xffffffffffff,N=10,j=16,u=Object.freeze({source:"ulid"});function F(e){let t=e||v(),r=t&&(t.crypto||t.msCrypto)||(typeof y.default<"u"?y.default:null);if(typeof r?.getRandomValues=="function")return()=>{let n=new Uint8Array(1);return r.getRandomValues(n),n[0]/255};if(typeof r?.randomBytes=="function")return()=>r.randomBytes(1).readUInt8()/255;if(y.default?.randomBytes)return()=>y.default.randomBytes(1).readUInt8()/255;throw new c({info:{code:"PRNG_DETECT",...u}},"Failed to find a reliable PRNG")}function v(){return B()?self:typeof window<"u"?window:typeof global<"u"?global:typeof globalThis<"u"?globalThis:null}function G(e,t){let r="";for(;e>0;e--)r=k(t)+r;return r}function b(e,t){if(isNaN(e))throw new c({info:{code:"ENC_TIME_NAN",...u}},`Time must be a number: ${e}`);if(e>w)throw new c({info:{code:"ENC_TIME_SIZE_EXCEED",...u}},`Cannot encode a time larger than ${w}: ${e}`);if(e<0)throw new c({info:{code:"ENC_TIME_NEG",...u}},`Time must be positive: ${e}`);if(Number.isInteger(e)===!1)throw new c({info:{code:"ENC_TIME_TYPE",...u}},`Time must be an integer: ${e}`);let r,n="";for(let o=t;o>0;o--)r=e%d,n=g.charAt(r)+n,e=(e-r)/d;return n}function V(e){let t,r=e.length,n,o,s=e,i=d-1;for(;!t&&r-->=0;){if(n=s[r],o=g.indexOf(n),o===-1)throw new c({info:{code:"B32_INC_ENC",...u}},"Incorrectly encoded string");if(o===i){s=T(s,r,g[0]);continue}t=T(s,r,g[o+1])}if(typeof t=="string")return t;throw new c({info:{code:"B32_INC_INVALID",...u}},"Failed incrementing string")}function B(){return typeof WorkerGlobalScope<"u"&&self instanceof WorkerGlobalScope}function x(e){let t=e||F(),r=0,n;return function(s){let i=isNaN(s)?Date.now():s;if(i<=r){let C=n=V(n);return b(r,N)+C}r=i;let m=n=G(j,t);return b(i,N)+m}}function k(e){let t=Math.floor(e()*d);return t===d&&(t=d-1),g.charAt(t)}function T(e,t,r){return t>e.length-1?e:e.substr(0,t)+r+e.substr(t+1)}var f=require("@raycast/api");var D=async(e,t)=>{try{let r=await f.LocalStorage.getItem("uuidHistory");if(r||(r="[]"),typeof r!="string")return;let n=JSON.parse(r);n.push({uuid:e,timestamp:new Date,type:t}),await f.LocalStorage.setItem("uuidHistory",JSON.stringify(n))}catch{await(0,f.showToast)({style:f.Toast.Style.Failure,title:"Error saving history",message:"Failed to save history to local storage"})}};async function U(e,t,r=!1,n="uuidV4"){let o=Array.from(Array(t)).map(()=>{let s=e();return r?s.toUpperCase():s});for(let s of o)await D(s,n);return o}var W=x(),_=1e4,X=async e=>{let{numberOfULIDsToGenerate:t}=e.arguments,{upperCaseLetters:r,defaultAction:n}=(0,a.getPreferenceValues)();t||(t="1");try{let o=parseInt(t,10);if(isNaN(o))throw new Error("INVALID_NUMBER");if(o<=_){let s=await U(W,o,r,"ulid");n==="copy"?await a.Clipboard.copy(s.join(`\r
`)):n==="paste"&&await a.Clipboard.paste(s.join(`\r
`));let i=n==="copy"?"Copied":"Pasted",m=s.length>1?`${i} ${s.length} new ULIDs.`:`${i} new ULID: ${s}`;await(0,a.showHUD)(`\u2705 ${m}`)}else await(0,a.showToast)({style:a.Toast.Style.Failure,title:"Too many ULIDs requested.",message:`${o} exceeds maximum ULIDs of ${_}. Try a lower number.`})}catch{await(0,a.showToast)({style:a.Toast.Style.Failure,title:"Invalid number.",message:"An invalid number has been provided. Try an actual number."})}};
