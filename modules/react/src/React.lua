--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/56e9feead0f91075ba0a4f725c9e4e343bca1c67/packages/react/src/React.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flowx
 *]]

 -- ROBLOX DEVIATION START: imports
local Packages = script.Parent.Parent
local ReactBinding = require(script.Parent["ReactBinding.roblox"])
local ReactNone = require(script.Parent["None.roblox"])
local ReactGlobals = require(Packages.ReactGlobals)
local LuauPolyfill = require(Packages.LuauPolyfill)
-- ROBLOX DEVIATION END

local ReactElementValidator = require(script.Parent.ReactElementValidator)
local createMutableSource = require(script.Parent.ReactMutableSource)
local ReactBaseClasses = require(script.Parent.ReactBaseClasses)
local ReactForwardRef = require(script.Parent.ReactForwardRef)
local ReactCreateRef = require(script.Parent.ReactCreateRef)
local ReactChildren = require(script.Parent.ReactChildren)
local ReactContext = require(script.Parent.ReactContext)
local ReactElement = require(script.Parent.ReactElement)
local ReactHooks = require(script.Parent.ReactHooks)
local ReactMemo = require(script.Parent.ReactMemo)
local ReactLazy = require(script.Parent.ReactLazy)
local Shared = require(Packages.Shared)
local ReactSharedInternals = Shared.ReactSharedInternals
local ReactSymbols = Shared.ReactSymbols
local ReactTypes = Shared

local SHOULD_VALIDATE = ReactGlobals.__DEV__
	or ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION_

type React_AbstractComponent<P, T> = ReactTypes.React_AbstractComponent<P, T>
type LazyComponent<T, P> = ReactLazy.LazyComponent<T, P>

export type React_StatelessFunctionalComponent<P> = ReactTypes.React_StatelessFunctionalComponent<P>
export type PureComponent<Props, State = nil> = ReactTypes.React_PureComponent<Props, State>
export type React_ElementProps<ElementType> = ReactTypes.React_ElementProps<ElementType>
export type ReactElement<P = LuauPolyfill.Object, T = any> = ReactTypes.ReactElement<P, T>
export type React_ComponentType<P> = ReactTypes.React_ComponentType<P>
export type ReactProviderType<T> = ReactTypes.ReactProviderType<T>
export type ReactContext<T> = ReactTypes.ReactContext<T>
export type React_Node = ReactTypes.React_Node

-- ROBLOX DEVIATION START: bindings support
export type ReactBindingUpdater<T> = ReactTypes.ReactBindingUpdater<T>
export type ReactBinding<T> = ReactTypes.ReactBinding<T>
-- ROBLOX DEVIATION END

type createElementFn = <P, T>(
	type_: React_StatelessFunctionalComponent<P>
		| React_ComponentType<P>
		| React_AbstractComponent<P, T>
		| string
		| ReactContext<any>
		| ReactProviderType<any>
		| ReactLazy.LazyComponent<T, P>,
	props: P?,
	...(React_Node | (...any) -> React_Node)
) -> ReactElement<P, T>

type cloneElementFn = <P, T>(
	element: ReactElement<P, T>,
	config: P?,
	...React_Node
) -> ReactElement<P, T>

local createElement: createElementFn = if SHOULD_VALIDATE
	then ReactElementValidator.createElementWithValidation
	else ReactElement.createElement

local cloneElement: cloneElementFn = if SHOULD_VALIDATE
	then ReactElementValidator.cloneElementWithValidation
	else ReactElement.cloneElement

local React = {
	Children = ReactChildren,
	createMutableSource = createMutableSource,
	createRef = ReactCreateRef.createRef,
	Component = ReactBaseClasses.Component,
	PureComponent = ReactBaseClasses.PureComponent,
	createContext = ReactContext.createContext,
	forwardRef = ReactForwardRef.forwardRef,
	lazy = ReactLazy.lazy,
	memo = ReactMemo.memo,
	useCallback = ReactHooks.useCallback,
	useContext = ReactHooks.useContext,
	useEffect = ReactHooks.useEffect,
	useImperativeHandle = ReactHooks.useImperativeHandle,
	useDebugValue = ReactHooks.useDebugValue,
	useLayoutEffect = ReactHooks.useLayoutEffect,
	useMemo = ReactHooks.useMemo,
	useMutableSource = ReactHooks.useMutableSource,
	useReducer = ReactHooks.useReducer,
	useRef = ReactHooks.useRef,
	-- ROBLOX deviation: bindings support
	useBinding = ReactHooks.useBinding,
	useState = ReactHooks.useState,
	Fragment = ReactSymbols.REACT_FRAGMENT_TYPE,
	Profiler = ReactSymbols.REACT_PROFILER_TYPE,
	StrictMode = ReactSymbols.REACT_STRICT_MODE_TYPE,
	unstable_DebugTracingMode = ReactSymbols.REACT_DEBUG_TRACING_MODE_TYPE,
	Suspense = ReactSymbols.REACT_SUSPENSE_TYPE,
	createElement = createElement,
	cloneElement = cloneElement,
	isValidElement = ReactElement.isValidElement,
	-- ROBLOX TODO: ReactVersion
	__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = ReactSharedInternals,
	-- Deprecated behind disableCreateFactory
	-- ROBLOX TODO: createFactory,
	-- Concurrent Mode
	-- ROBLOX TODO: useTransition,
	-- ROBLOX TODO: startTransition,
	-- ROBLOX TODO: useDeferredValue,
	-- ROBLOX TODO: REACT_SUSPENSE_LIST_TYPE as SuspenseList,
	unstable_LegacyHidden = ReactSymbols.REACT_LEGACY_HIDDEN_TYPE,
	-- enableBlocksAPI
	-- ROBLOX TODO: block,
	-- enableFundamentalAPI
	-- ROBLOX TODO: createFundamental as unstable_createFundamental,
	-- enableScopeAPI
	-- ROBLOX TODO: REACT_SCOPE_TYPE as unstable_Scope,
	-- ROBLOX TODO: useOpaqueIdentifier as unstable_useOpaqueIdentifier,

	-- ROBLOX deviation: bindings support
	createBinding = ReactBinding.create,
	joinBindings = ReactBinding.join,

	-- ROBLOX DEVIATION: export the `None` placeholder for use with setState
	None = ReactNone,

	-- ROBLOX DEVIATION: export Change, Event, and Tag from React
	Change = Shared.Change,
	Event = Shared.Event,
	Tag = Shared.Tag,

	-- ROBLOX DEVIATION: used by error reporters to parse caught errors. React
	-- stringifies at its boundaries to maintain compatibility with
	-- ScriptContext signals that may ultimately catch them
	unstable_parseReactError = Shared.parseReactError,
}

-- ROBLOX deviation: bindings universal subscriber
@[deprecated{ use = "Binding:_subscribe()" }]
function React.__subscribeToBinding<V>(
	binding: ReactBinding<V>,
	f: (value: V) -> ()
): () -> ()
	return binding:_subscribe(f)
end

return table.freeze(React)
