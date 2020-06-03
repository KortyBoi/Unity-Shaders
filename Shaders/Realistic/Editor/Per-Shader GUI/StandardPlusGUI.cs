//created for KortyBoi's Standard+ Shader v1.0
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
//using KortyShaderUI;

public class StandardPlusEditor : ShaderGUI
{
	private static class Styles
    {
        // sections
        public static GUIContent MainSection = new GUIContent("Main", "Main Texture, Colors and Normals");
		public static GUIContent EmissionSection = new GUIContent("Emission", "Varius Options containing Emission Properties");
		public static GUIContent MatallicSection = new GUIContent("Matallic, Smoothing and More", "Matallic, Smoothing and more Settings");
		public static GUIContent TranslucencySection = new GUIContent("Translucency", "Translucency Options");
		
		// Main
		public static GUIContent MainColor = new GUIContent("Color", "Color used for tinting the main texture");
		public static GUIContent MainTex = new GUIContent("Main Texture", "Main texture for the shader");
		public static GUIContent Contrast = new GUIContent("Contrast", "Darkens Texture");
		public static GUIContent NormalMap = new GUIContent("Normal Map", "Bump map");
		public static GUIContent NormalScale = new GUIContent("Normal Scale", "Changes the values of how much the normal map is being simulated");
		
		// Emission
		public static GUIContent EmissionToggle = new GUIContent("Use Emission?", "Do you want to use Emission?");
		public static GUIContent EmissionTexture = new GUIContent("Texture", "Set a texture to be emitted");
		public static GUIContent EmissionColor = new GUIContent("Color", "Changes the intenstiy of the Emitted Texture");
		public static GUIContent EmissionScale = new GUIContent("Intensity", "Change brightness of emission");
		
		public static GUIContent EmissionShift = new GUIContent("Color Shift", "Have Emission shift between two colors");
		public static GUIContent EShiftScale = new GUIContent("Shift Value", "Changes intenstiy of the color shift brightness");
		public static GUIContent EShiftColor1 = new GUIContent("Color 1", "First color for shift");
		public static GUIContent EShiftColor2 = new GUIContent("Color 2", "Second color for shift");
		public static GUIContent EShiftRate = new GUIContent("Shift Pause Rate /sec", "Changes how frequent the colors will shift");
		
		public static GUIContent OutlineColor = new GUIContent("Outline Color", "Changes color of an outline");
		public static GUIContent OutlineWidth = new GUIContent("Outline Width", "Adds thicc-ness to an outline | 0 = no outline");
		
		// Matallic Smoothness AO
		public static GUIContent MatallicToggle = new GUIContent("is Matallic", "Makes material look like metal");
		public static GUIContent Matallicness = new GUIContent("Metalness", "Changes how metally it'll look");
		public static GUIContent Smoothness = new GUIContent("Smoothness", "Smooths reflected light | Soft 0 - 1 Hard");
		public static GUIContent MoreSmoothToggle = new GUIContent("Extra Smoothness", "Adds even more smoothness. Starts at 1");
		public static GUIContent MoreSmoothnes = new GUIContent("Extra Smoothness", "Smooths reflected light");
		public static GUIContent AOToggle = new GUIContent("has Ambient Occlusion?", "");
		public static GUIContent AOScale = new GUIContent("Strength", "Changes value of the Ambient Occlusion");
		
		// Translucency
		public static GUIContent TranslucencyToggle = new GUIContent("Toggle Feature", "Adds Translucency Options");
		public static GUIContent TranslucencyStrength = new GUIContent("Strength", "$");
		public static GUIContent TranslucencyDistortion = new GUIContent("Distortion", "$");
		public static GUIContent TranslucencyScattering = new GUIContent("Scattering", "$");
		public static GUIContent TranslucencyDirect = new GUIContent("Direct", "$");
		public static GUIContent TranslucencyAmbient = new GUIContent("Ambience", "$");
		public static GUIContent TranslucencyShadow = new GUIContent("Shadow", "$");
		
	}
	
	GUIStyle m_sectionStyle;
    //MaterialProperty m_ = null;
	MaterialProperty m_MainColor = null;
	MaterialProperty m_MainTex = null;
	MaterialProperty m_Contrast = null;
	MaterialProperty m_Normal = null;
	MaterialProperty m_NormalIntensity = null;
	
	MaterialProperty m_Emission = null;
	MaterialProperty m_EmissionColor = null;
	MaterialProperty m_EmissionValue = null;
	MaterialProperty m_EmissionTex = null;
	MaterialProperty m_EmissionShift = null;
	MaterialProperty m_ShiftValue = null;
	MaterialProperty m_ColorShift1 = null;
	MaterialProperty m_ColorShift2 = null;
	MaterialProperty m_ShiftPausessec = null;
	MaterialProperty m_OutlineWidth = null;
	MaterialProperty m_OutlineColor = null;
	
	MaterialProperty m_Smoothness = null;
	MaterialProperty m_ExtraSmooth = null;
	MaterialProperty m_ExtraSmoothness = null;
	MaterialProperty m_IsMatallic = null;
	MaterialProperty m_Metalness = null;
	MaterialProperty m_ToggleAmbientOcclusion = null;
	MaterialProperty m_AmbientOcclusionStrength = null;
	
	MaterialProperty m_ToggleTransluency = null;
	MaterialProperty m_Translucency = null;
	MaterialProperty m_TransNormalDistortion = null;
	MaterialProperty m_TransScattering = null;
	MaterialProperty m_TransDirect = null;
	MaterialProperty m_TransAmbient = null;
	MaterialProperty m_TransShadow = null;
	
	bool m_mainOptions = true;
	bool m_EmissionOptions;
	bool m_MatallicOptions;
	bool m_TranslucencyOptions;
	bool m_Credits;
	bool m_ChangeLog /*= true*/;
	
	private void FindProperties(MaterialProperty[] props)
    {
		//m_ = FindProperty("_", props);
		m_MainColor = FindProperty("_MainColor", props);
		m_MainTex = FindProperty("_MainTex", props);
		m_Contrast = FindProperty("_Contrast", props);
		m_Normal = FindProperty("_Normal", props);
		m_NormalIntensity = FindProperty("_NormalIntensity", props);
		
		m_Emission = FindProperty("_Emission", props);
		m_EmissionColor = FindProperty("_EmissionColor", props);
		m_EmissionValue = FindProperty("_EmissionValue", props);
		m_EmissionTex = FindProperty("_EmissionTex", props);
		m_EmissionShift = FindProperty("_EmissionShift", props);
		m_ShiftValue = FindProperty("_ShiftValue", props);
		m_ColorShift1 = FindProperty("_ColorShift1", props);
		m_ColorShift2 = FindProperty("_ColorShift2", props);
		m_ShiftPausessec = FindProperty("_ShiftPausessec", props);
		m_OutlineWidth = FindProperty("_OutlineWidth", props);
		m_OutlineColor = FindProperty("_OutlineColor", props);
		
		m_Smoothness = FindProperty("_Smoothness", props);
		m_ExtraSmooth = FindProperty("_ExtraSmooth", props);
		m_ExtraSmoothness = FindProperty("_ExtraSmoothness", props);
		m_IsMatallic = FindProperty("_IsMatallic", props);
		m_Metalness = FindProperty("_Metalness", props);
		m_ToggleAmbientOcclusion = FindProperty("_ToggleAmbientOcclusion", props);
		m_AmbientOcclusionStrength = FindProperty("_AmbientOcclusionStrength", props);
		
		m_ToggleTransluency = FindProperty("_ToggleTransluency", props);
		m_Translucency = FindProperty("_Translucency", props);
		m_TransNormalDistortion = FindProperty("_TransNormalDistortion", props);
		m_TransScattering = FindProperty("_TransScattering", props);
		m_TransDirect = FindProperty("_TransDirect", props);
		m_TransAmbient = FindProperty("_TransAmbient", props);
		m_TransShadow = FindProperty("_TransShadow", props);
	}
	
	private void SetupStyle()
    {
        m_sectionStyle = new GUIStyle(EditorStyles.boldLabel);
        m_sectionStyle.alignment = TextAnchor.MiddleCenter;
    }

    private void ToggleDefine(Material mat, string define, bool state)
    {
        if (state)
        {
            mat.EnableKeyword(define);
        }
        else
        {
            mat.DisableKeyword(define);
        }
    }
    void ToggleDefines(Material mat)
    {
    }

    void LoadDefaults(Material mat)
    {
    }

    void DrawHeader(ref bool enabled, ref bool options, GUIContent name)
    {
        var r = EditorGUILayout.BeginHorizontal("box");
        enabled = EditorGUILayout.Toggle(enabled, EditorStyles.radioButton, GUILayout.MaxWidth(15.0f));
        options = GUI.Toggle(r, options, GUIContent.none, new GUIStyle());
        EditorGUILayout.LabelField(name, m_sectionStyle);
        EditorGUILayout.EndHorizontal();
    }
	
	void DrawMasterLabel()
    {
        GUIStyle style = new GUIStyle(GUI.skin.label);
        style.richText = true;
        style.alignment = TextAnchor.MiddleCenter;

        EditorGUILayout.LabelField("<size=20><color=#00ffaa>Standard+ <size=15>v1.0</size></color></size>", style, GUILayout.MinHeight(24));
		EditorGUILayout.Space();
    }
	
	void DrawBottomLabel()
    {
        GUIStyle style = new GUIStyle(GUI.skin.label);
        style.richText = true;
		
		EditorGUILayout.LabelField("GUI: <color=#e029b8>PoiyomiToon ~v2.3</color>, ShurikenModule", style, GUILayout.MinHeight(15));
		EditorGUILayout.LabelField("Shader Editor: <color=#e09429>Amplify Shader Editor</color>", style, GUILayout.MinHeight(15));
            if (GUILayout.Button("Available at the Unity Asset Store"))
            {
                Application.OpenURL("http://u3d.as/y3X ");
            }
			
		ExtraSpace();
		
        style.alignment = TextAnchor.MiddleCenter;

        EditorGUILayout.LabelField("<size=15><color=#ffffff>Made by</color> <color=#00ffaa>KortyBoi</color></size><size=10><color=#29abe0>#0001</color></size>", style, GUILayout.MinHeight(20));
		
		EditorGUILayout.Space();
		GUILayout.BeginHorizontal();
		
			GUI.backgroundColor = new Color32(0, 255, 170, 125);
            if (GUILayout.Button("My Website"))
            {
                Application.OpenURL("https://kortyboi.com/");
            }
			
			GUI.backgroundColor = new Color32(41, 171, 224, 125);
            if (GUILayout.Button("Donate"))
            {
                Application.OpenURL("https://ko-fi.com/kortyboi");
            }
			
            GUILayout.EndHorizontal();
    }
	
	void DrawChangeLog()
	{
		GUIStyle style = new GUIStyle(GUI.skin.label);
        style.richText = true;
        style.alignment = TextAnchor.MiddleLeft;

        //EditorGUILayout.LabelField("<size=15><color=#ffffff>Change Log:</color></size>", style, GUILayout.MinHeight(22));
		
		EditorGUILayout.Space();
		EditorGUILayout.LabelField("<size=13.5><color=#e09429><b>v1.0</b></color></size>", style, GUILayout.MinHeight(15));
		EditorGUILayout.LabelField(" <size=10> - Initial Release</size>", style, GUILayout.MinHeight(15));
		/*
		EditorGUILayout.LabelField("<size=13.5><color=red><b>v </b></color></size>", style, GUILayout.MinHeight(10));
		EditorGUILayout.LabelField(" <size=10> <color=red> - </color></size>", style, GUILayout.MinHeight(10));
		*/
	}
	
	void ExtraSpace()
	{
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		EditorGUILayout.Space();
	}
	
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
		Material material = materialEditor.target as Material;
		
        FindProperties(props);
		SetupStyle();
        LoadDefaults(material);
		DrawMasterLabel();
		
		// main section
        m_mainOptions = KortyShaderUI.Foldout("Main Texture, Color and Normals", m_mainOptions);
        if (m_mainOptions)
        {
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(m_MainColor, Styles.MainColor);
			materialEditor.ShaderProperty(m_MainTex, Styles.MainTex);
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(m_Contrast, Styles.Contrast);
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(m_Normal, Styles.NormalMap);
			materialEditor.ShaderProperty(m_NormalIntensity, Styles.NormalScale);

            EditorGUILayout.Space();
        }
		
		// Emission section
        m_EmissionOptions = KortyShaderUI.Foldout("Emission", m_EmissionOptions);
        if (m_EmissionOptions)
        {
            EditorGUILayout.Space();

			materialEditor.ShaderProperty(m_Emission, Styles.EmissionToggle);
			materialEditor.ShaderProperty(m_EmissionTex, Styles.EmissionTexture);
			materialEditor.ShaderProperty(m_EmissionColor, Styles.EmissionColor);
			materialEditor.ShaderProperty(m_EmissionValue, Styles.EmissionScale);
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(m_EmissionShift, Styles.EmissionShift);
			materialEditor.ShaderProperty(m_ShiftValue, Styles.EShiftScale);
			materialEditor.ShaderProperty(m_ColorShift1, Styles.EShiftColor1);
			materialEditor.ShaderProperty(m_ColorShift2, Styles.EShiftColor2);
			materialEditor.ShaderProperty(m_ShiftPausessec, Styles.EShiftRate);
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(m_OutlineWidth, Styles.OutlineWidth);
			materialEditor.ShaderProperty(m_OutlineColor, Styles.OutlineColor);

            EditorGUILayout.Space();
        }
		
		// Outline section
        m_MatallicOptions = KortyShaderUI.Foldout("Matallic, Smoothness and Ambient Occlusion", m_MatallicOptions);
        if (m_MatallicOptions)
        {
            EditorGUILayout.Space();

			materialEditor.ShaderProperty(m_IsMatallic, Styles.MatallicToggle);
			materialEditor.ShaderProperty(m_Metalness, Styles.Matallicness);
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(m_Smoothness, Styles.Smoothness);
			materialEditor.ShaderProperty(m_ExtraSmooth, Styles.MoreSmoothToggle);
			materialEditor.ShaderProperty(m_ExtraSmoothness, Styles.MoreSmoothnes);
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(m_ToggleAmbientOcclusion, Styles.AOToggle);
			materialEditor.ShaderProperty(m_AmbientOcclusionStrength, Styles.AOScale);

            EditorGUILayout.Space();
        }
		
		// Translucency section
        m_TranslucencyOptions = KortyShaderUI.Foldout("Translucency", m_TranslucencyOptions);
        if (m_TranslucencyOptions)
        {
            EditorGUILayout.Space();

			materialEditor.ShaderProperty(m_ToggleTransluency, Styles.TranslucencyToggle);
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(m_Translucency, Styles.TranslucencyStrength);
			materialEditor.ShaderProperty(m_TransNormalDistortion, Styles.TranslucencyDistortion);
			materialEditor.ShaderProperty(m_TransScattering, Styles.TranslucencyScattering);
			materialEditor.ShaderProperty(m_TransDirect, Styles.TranslucencyDirect);
			materialEditor.ShaderProperty(m_TransAmbient, Styles.TranslucencyAmbient);
			materialEditor.ShaderProperty(m_TransShadow, Styles.TranslucencyShadow);

            EditorGUILayout.Space();
        }
		
		ExtraSpace();
		
		//Change Log
		m_ChangeLog = KortyShaderUI.Foldout("Change Log", m_ChangeLog);
		if (m_ChangeLog)
		{
			EditorGUILayout.Space();

            DrawChangeLog();
			
            EditorGUILayout.Space();
        }
		
		// Credits section
        m_Credits = KortyShaderUI.Foldout("Credits", m_Credits);
        if (m_Credits)
        {
            EditorGUILayout.Space();

            DrawBottomLabel();
			
            EditorGUILayout.Space();
        }
		
		
		ToggleDefines(material);
    }
}